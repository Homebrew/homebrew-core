class Powershell < Formula
  require "json"

  desc "Command-line shell and scripting language"
  homepage "https://github.com/PowerShell/PowerShell"
  url "https://github.com/PowerShell/PowerShell.git",
    tag:      "v7.5.4",
    revision: "7c8d9e7e0ed2fc1f2caf50746fe9fef720ca2a0a"
  license "MIT"

  depends_on "dotnet@9"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    dotnet = Formula["dotnet@9"]
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_CLI_HOME"] = buildpath
    ENV["NUGET_PACKAGES"] = buildpath/".nuget/packages"
    ENV["DOTNET_ROOT"] = dotnet.opt_libexec
    inreplace "global.json", /"version": "\d.*"/, "\"version\": \"#{dotnet.version}\""

    target_framework = "net#{dotnet.version.major_minor}"
    dotnet_sources = [
      "--source", "https://api.nuget.org/v3/index.json"
    ]

    dotnet_restore_flags = %w[
      --disable-build-servers
      --use-current-runtime
      --nologo
    ]
    dotnet_publish_flags = %W[
      --disable-build-servers
      --nologo
      -c Release
      --no-self-contained
      --use-current-runtime
      -f #{target_framework}
      --property:PublishReadyToRun=false
      --property:GenerateFullPaths=true
      --property:ErrorOnDuplicatePublishOutputFiles=false
      --property:IsWindows=false
    ]
    dotnet_run_flags = %W[
      --framework #{target_framework}
      -c Release
    ]

    system "dotnet", "restore", "PowerShell.sln", *dotnet_restore_flags, *dotnet_sources

    cd "src/ResGen" do
      # Adding framework option to force out version
      system "dotnet", "run", *dotnet_run_flags
    end

    # Build the dummy project https://github.com/PowerShell/PowerShell/blob/v7.5.4/build.psm1#L2572-L2589
    inc_file = "powershell.inc"
    target_file = buildpath/"src/Microsoft.PowerShell.SDK/obj/Microsoft.PowerShell.SDK.csproj.TypeCatalog.targets"
    target_file.dirname.mkpath
    target_file.write <<~XML
      <Project>
          <Target Name="_GetDependencies"
                  DependsOnTargets="ResolveAssemblyReferencesDesignTime">
              <ItemGroup>
                  <_RefAssemblyPath Include="%(_ReferencesFromRAR.OriginalItemSpec)%3B" Condition=" '%(_ReferencesFromRAR.NuGetPackageId)' != 'Microsoft.Management.Infrastructure' "/>
              </ItemGroup>
              <WriteLinesToFile File="$(_DependencyFile)" Lines="@(_RefAssemblyPath)" Overwrite="true" />
          </Target>
      </Project>
    XML

    system "dotnet", "msbuild",
           "src/Microsoft.PowerShell.SDK/Microsoft.PowerShell.SDK.csproj",
           "-t:_GetDependencies",
           "-property:DesignTimeBuild=true;_DependencyFile=#{buildpath}/src/TypeCatalogGen/#{inc_file}",
           "-nologo"

    cd "src/TypeCatalogGen" do
      system "dotnet", "run", *dotnet_run_flags, "../System.Management.Automation/CoreCLR/CorePsTypeCatalog.cs",
inc_file
    end

    system "dotnet", "publish", "src/powershell-unix/powershell-unix.csproj", *dotnet_publish_flags

    # Dotnet RIDs use "x64" for Intel.
    runtime = "#{OS.mac? ? "osx" : "linux"}-#{Hardware::CPU.intel? ? "x64" : "arm64"}"
    publish_path = buildpath/"src/powershell-unix/bin/Release/#{target_framework}/#{runtime}/publish"

    module_copy_script = buildpath/"homebrew-copy-psgallery-modules.ps1"
    module_copy_script.write <<~PS1
      $ErrorActionPreference = 'Stop'
      Import-Module '#{buildpath/"build.psm1"}' -Force
      Copy-PSGalleryModules -CsProjPath '#{buildpath/"src/Modules/PSGalleryModules.csproj"}' -Destination '#{publish_path/"Modules"}' -Force
    PS1

    # Hardcode the environment object as we dont have brew command. See https://github.com/PowerShell/PowerShell/blob/v7.5.4/build.psm1#L124-L224
    mock_environment = <<~PS1
      $environment = [PSCustomObject]@{
        IsWindows = $false
        IsLinux = "$#{OS.linux?}"
        IsMacOS = "$#{OS.mac?}"
      }
    PS1

    inreplace "build.psm1", /^\$environment = Get-EnvironmentInformation$/, mock_environment.chomp
    system publish_path/"pwsh", "-NoLogo", "-NoProfile", "-File", module_copy_script

    clear_native_dependencies(publish_path, runtime, dotnet)

    libexec.install publish_path.glob("*")
    (bin/"pwsh").write_env_script libexec/"pwsh",
                                  DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"

    man1.install buildpath/"assets/manpage/pwsh.1"
    deuniversalize_machos libexec/"libpsl-native.dylib" if OS.mac?
  end

  # See https://github.com/PowerShell/PowerShell/blob/v7.5.4/build.psm1#L3804
  def clear_native_dependencies(publish_path, runtime, dotnet)
    diasym_suffix = runtime.end_with?("-x64") ? "amd64" : "arm64"
    diasym_file = "microsoft.diasymreader.native.#{diasym_suffix}.dll"
    deps_path = publish_path/"pwsh.deps.json"
    deps = JSON.parse(deps_path.read)
    target = ".NETCoreApp,Version=v#{dotnet.version.major_minor}/#{runtime}"

    # Find the runtime pack for the specified target framework
    pack = deps.dig("targets", target)&.keys&.find { |k| k.start_with?("runtimepack.Microsoft.NETCore.App.Runtime") }
    deps.dig("targets", target, pack, "native")&.delete(diasym_file)

    # Replace place the dependency file with the clean one
    rm deps_path
    deps_path.write(JSON.pretty_generate(deps))
    rm publish_path/diasym_file if (publish_path/diasym_file).exist?
  end

  def caveats
    <<~EOS
      CurrentUser configs are at:
        ~/.local/share/powershell/
      CurrentUserAllHosts configs are at:
        ~/.config/powershell/

      To use Homebrew in PowerShell, run:
        New-Item -Path (Split-Path -Parent -Path $PROFILE.CurrentUserAllHosts) -ItemType Directory -Force
        Add-Content -Path $PROFILE.CurrentUserAllHosts -Value '$(#{HOMEBREW_PREFIX}/bin/brew shellenv) | Invoke-Expression'

      To add Homebrew pwsh completions see: https://docs.brew.sh/Shell-Completion#configuring-completions-in-pwsh

    EOS
  end

  test do
    version_output = shell_output("#{bin}/pwsh -NoLogo -NoProfile -c '$PSVersionTable.PSVersion.ToString()'").chomp
    pwsh_version_output = shell_output("#{bin}/pwsh -Version")
    assert_equal version.to_s, version_output
    assert_match version_output, pwsh_version_output

    pipeline_output = shell_output("#{bin}/pwsh -NoLogo -NoProfile -c '(6..7 | Measure-Object -Sum).Sum'").chomp
    assert_equal "13", pipeline_output

    local_module = testpath/"HomebrewDemo.psm1"

    local_module.write <<~PS1
      function Get-HomebrewDemo {
        $PSHOME
      }
      Export-ModuleMember -Function Get-HomebrewDemo
    PS1

    local_module_output = shell_output(
      "#{bin}/pwsh -NoLogo -NoProfile -c 'Import-Module \"#{local_module}\"; Get-HomebrewDemo'",
    ).chomp

    assert_equal libexec.to_s, local_module_output

    module_cmd = "Import-Module PowerShellGet; [bool](Get-Command Install-Module )"
    module_output = shell_output("#{bin}/pwsh -NoLogo -NoProfile -c '#{module_cmd}'").lines.last.chomp
    assert_equal "True", module_output
  end
end

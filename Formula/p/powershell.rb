class Powershell < Formula
  desc "Command-line shell and scripting language"
  homepage "https://github.com/PowerShell/PowerShell"
  url "https://github.com/PowerShell/PowerShell.git",
      tag:      "v7.6.4",
      revision: "abeb8444d065feeccf80bda83eed5675a37719c1"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8c30080631d91ef4b2ebc755af4e31aceedd223dbab5bda0e5d1ecdfb809c62f"
    sha256 cellar: :any, arm64_sequoia: "e63a32f6b2c2e1d5f57955307dd92d85cc17a0a0ec115fd5e49dd583a3c2e786"
    sha256 cellar: :any, arm64_sonoma:  "5fe9dd8f4d8b38cc87d76b5774773c933534951bc48be573f4318093edf5e49f"
    sha256 cellar: :any, sonoma:        "efd0f1c894f929abeac90a7ef875244eb5cb0561e6aba9ff6f93565323eea2b8"
    sha256 cellar: :any, arm64_linux:   "15f2df2bdea69c18b4d18e2a78c83e96317ac92e68baa5586c73ee2457ed9145"
    sha256 cellar: :any, x86_64_linux:  "cad1cd4ae5e3b7337b9bfa4e19e36e55cbb00915b918fdce5e35ae9a11f9c16e"
  end

  depends_on "dotnet"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    dotnet = Formula["dotnet"]
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
      --property:WarningsNotAsErrors=NU1903
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
      --property:ReleaseTag=#{version}
      --property:WarningsNotAsErrors=NU1903
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
    dotnet_msbuild_flags = %W[
      -t:_GetDependencies
      -property:DesignTimeBuild=true;_DependencyFile=#{buildpath}/src/TypeCatalogGen/#{inc_file}
      -nologo
      -p:WarningsNotAsErrors=NU1903
    ]
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
           "src/Microsoft.PowerShell.SDK/Microsoft.PowerShell.SDK.csproj", *dotnet_msbuild_flags

    cd "src/TypeCatalogGen" do
      system "dotnet", "run", *dotnet_run_flags,
             "../System.Management.Automation/CoreCLR/CorePsTypeCatalog.cs", inc_file
    end

    system "dotnet", "publish", "src/powershell-unix/powershell-unix.csproj", *dotnet_publish_flags

    # Dotnet RIDs use "x64" for Intel.
    os = OS.mac? ? "osx" : "linux"
    arch = Hardware::CPU.intel? ? "x64" : "arm64"
    runtime = "#{os}-#{arch}"
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

    (libexec/"ref").mkpath

    ln_s dotnet.opt_libexec.glob("packs/Microsoft.NETCore.App.Ref/*/ref/#{target_framework}").first.glob("*"),
         libexec/"ref"

    (bin/"pwsh").write_env_script libexec/"pwsh",
                                  DOTNET_ROOT: dotnet.opt_libexec

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
    rm publish_path/diasym_file, force: true
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

    module_cmd = "Import-Module PowerShellGet; [bool](Get-Command Install-Module)"
    module_output = shell_output("#{bin}/pwsh -NoLogo -NoProfile -c '#{module_cmd}' 2>&1")

    # If this produces an error try compiling powershell from source and increment revision
    refute_match(/InternalWebProxy/, module_output,
                                     "Probbably newer .NET runtime version than last build. Try recompiling")
    module_output = module_output.lines.last.chomp
    assert_equal "True", module_output
  end
end

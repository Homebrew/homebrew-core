class Opentap < Formula
  desc "Fast and easy development and execution of automated tests"
  homepage "https://opentap.io"
  url "https://github.com/opentap/opentap/archive/refs/tags/v9.24.2.tar.gz"
  sha256 "a8015e1781899690027e2c65c0452e9dc91914d71c824bc1c2c6985a034aa55a"
  license "MPL-2.0"

  depends_on "dotnet"

  uses_from_macos "unzip" => :build

  def install
    os = OS.mac? ? "MacOS" : "Linux"
    arch = Hardware::CPU.intel? ? "x64" : "arm64"
    package_output_path = buildpath/"OpenTAP.TapPackage"
    dotnet = Formula["dotnet"]
    args = %W[
      --configuration Release
      /p:AssemblyVersion=#{version}
      /p:FileVersion=#{version}
      /p:InformationalVersion=#{version}
      /p:Version=#{version}
    ]

    # Build OpenTAP
    system "dotnet", "build", "tap/tap.csproj", *args
    system "dotnet", "build", "Cli/Tap.Cli.csproj", *args
    system "dotnet", "build", "Package/Tap.Package.csproj", *args
    system "dotnet", "build", "BasicSteps/Tap.Plugins.BasicSteps.csproj", *args

    # Replace the version in the package.xml file
    inreplace "package.xml", "$(GitVersion)", version.to_s

    # Create the TapPackage
    Dir.chdir("bin/Release") do
      with_env(Platform: os, Architecture: arch, Sign: "false") do
        system "./tap.sh", "package", "create", "../../package.xml", "-o", package_output_path
      end
    end

    # Extract the TapPackage
    mkdir_p buildpath/"output"
    system "unzip", package_output_path, "-d", buildpath/"output"

    # Install the output of the TapPackage
    prefix.install Dir[buildpath/"output/*"]

    # Remove the libgit2 dependency from the package.xml file - Needed to verify the package
    inreplace prefix/"Packages/OpenTAP/package.xml", %r{<File .+libgit2(.|\s)+?</File>}, ""

    # Make the tap script executable - Used when opentap wants to run isolated
    chmod 0755, prefix/"tap"

    # Create a symlink to the tap script
    (bin/"tap").write_env_script dotnet, prefix/"tap.dll", DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  test do
    os = OS.mac? ? "MacOS" : "Linux"
    arch = Hardware::CPU.intel? ? "x64" : "arm64"
    assert_includes shell_output("cat #{prefix}/Packages/OpenTAP/package.xml"), "OS=\"#{os}\""
    assert_includes shell_output("cat #{prefix}/Packages/OpenTAP/package.xml"), "Architecture=\"#{arch}\""
    assert_includes shell_output("#{bin}/tap"), "Valid commands are"

    assert_includes shell_output("#{bin}/tap package verify OpenTAP"), "Package 'OpenTAP' verified."
  end
end

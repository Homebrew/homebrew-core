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

    # Even though the LC_ID_DYLIB path is an @rpath type, brew still updates it to an absolute path.
    # This means we need to update the libgit2 hash in the OpenTAP package.xml file, since the hash has changed.
    # This only needed on MacOS
    # Use command `otool -L libgit2-b7bad55.dylib.arm64` to get path.
    # Read more about LC_ID_DYLIB here: https://forums.developer.apple.com/forums/thread/736719 and https://developer.apple.com/library/archive/documentation/DeveloperTools/Conceptual/DynamicLibraries/100-Articles/RunpathDependentLibraries.html
    if OS.mac?
      if Hardware::CPU.intel?
        inreplace prefix/"Packages/OpenTAP/package.xml",
        "B661196093BBE2910813B073AA121C0D955040D5",
        "B81E44ED2C569CDD052CE6E717ADB26F62876020"
      else
        inreplace prefix/"Packages/OpenTAP/package.xml",
        "AFA701FDB44E3C5F44E8B0D972BD40A4BBECC5C2",
        "F9085086CC8323A9BFF7786309C4D3BF97949A3A"
      end
    end

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

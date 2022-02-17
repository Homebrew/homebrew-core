class Kryptor < Formula
  desc "Simple, modern, and secure file encryption and signing"
  homepage "https://www.kryptor.co.uk/"
  url "https://github.com/samuel-lucas6/Kryptor/archive/v3.1.0.tar.gz"
  sha256 "e7372ac4ccc4676fa6079bcc7be257c3677003b8ec33df486a4d43ba8bd1f3af"
  license "GPL-3.0-or-later"

  depends_on "dotnet"

  def install
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    system "dotnet", "publish", "src/KryptorCLI/KryptorCLI.csproj",
           "-c", "Release",
           "-r", "#{os}-#{arch}",
           "-p:PublishTrimmed=true",
           "-p:IncludeNativeLibrariesForSelfExtract=true",
           "-p:PublishSingleFile=true",
           "--self-contained", "true"

    env = { DOTNET_ROOT: "${DOTNET_ROOT:-#{Formula["dotnet"].opt_libexec}}" }
    (bin/"kryptor").write_env_script libexec/"kryptor", env
  end
end

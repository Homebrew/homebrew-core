class GitCredentialManager < Formula
  desc "Stores Git credentials for Visual Studio Team Services"
  homepage "https://docs.microsoft.com/vsts/git/set-up-credential-managers"
  url "https://github.com/GitCredentialManager/git-credential-manager/archive/refs/tags/v2.0.886.tar.gz"
  sha256 "8e07dccabfc4af5d0e82a0657c16e3858fd88995b181b9be86ffcdaa399e7f4c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f978fdd8c281d14ff2b28c380079db4b7927b585bc77432ac81339adc2d332c1"
  end

  depends_on "dotnet@6"

  on_macos do
    depends_on "coreutils" => :build # needs GNU ln
  end

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin"
    os = OS.mac? ? "osx" : "linux"
    cpu = Hardware::CPU.arm? ? "arm64" : "x64"
    cd "src/linux/Packaging.Linux" do
      inreplace "build.sh", 'INSTALL_LOCATION="/usr/local"', %Q(INSTALL_LOCATION="#{prefix}")
      inreplace "layout.sh", "RUNTIME=linux-x64", "RUNTIME=#{os}-#{cpu}"
      system "./build.sh", "--configuration=Release", "--version=#{version}", "--install-from-source=true"
    end
  end

  test do
    system "#{bin}/git-credential-manager", "--version"
  end
end

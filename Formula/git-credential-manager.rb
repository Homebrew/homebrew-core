class GitCredentialManager < Formula
  desc "Stores Git credentials for Visual Studio Team Services"
  homepage "https://docs.microsoft.com/vsts/git/set-up-credential-managers"
  url "https://github.com/Microsoft/Git-Credential-Manager-for-Mac-and-Linux/releases/download/git-credential-manager-2.0.4/git-credential-manager-2.0.4.jar"
  sha256 "fb8536aac9b00cdf6bdeb0dd152bb1306d88cd3fdb7a958ac9a144bf4017cad7"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f978fdd8c281d14ff2b28c380079db4b7927b585bc77432ac81339adc2d332c1"
  end

  # "This project has been superceded by Git Credential Manager Core":
  # https://github.com/microsoft/Git-Credential-Manager-Core
  disable! date: "2022-07-31", because: :repo_archived

  depends_on "openjdk"

  def install
    libexec.install "git-credential-manager-#{version}.jar"
    bin.write_jar_script libexec/"git-credential-manager-#{version}.jar", "git-credential-manager"
  end

  test do
    system "#{bin}/git-credential-manager", "version"
  end
end

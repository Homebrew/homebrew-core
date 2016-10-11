class GitCredentialManager < Formula
  desc "Stores Git credentials for Visual Studio Team Services"
  homepage "https://java.visualstudio.com/Docs/tools/gitcredentialmanager"
  url "https://github.com/Microsoft/Git-Credential-Manager-for-Mac-and-Linux/releases/download/git-credential-manager-2.0.2/git-credential-manager-2.0.2.jar"
  sha256 "eb51da17da648f36a3aa7b3b3a28250fc9da80ae080b87bafa23b54b42f3c783"

  bottle :unneeded

  depends_on :java => "1.6+"

  def install
    libexec.install "git-credential-manager-#{version}.jar"
    bin.write_jar_script libexec/"git-credential-manager-#{version}.jar", "git-credential-manager"
  end

  test do
    system "#{bin}/git-credential-manager", "version"
  end
end

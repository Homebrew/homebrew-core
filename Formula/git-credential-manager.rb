class GitCredentialManager < Formula
  desc "Stores Git credentials for Visual Studio Team Services"
  homepage "https://java.visualstudio.com/Docs/tools/gitcredentialmanager"
  url "https://github.com/Microsoft/Git-Credential-Manager-for-Mac-and-Linux/releases/download/git-credential-manager-2.0.3/git-credential-manager-2.0.3.jar"
  sha256 "ee7a11486dffbea366c79500395d9f1384fe4dd3f91b49e09e6bc2ed8ab5f65a"

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

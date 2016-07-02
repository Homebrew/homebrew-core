class GitCredentialManager < Formula
  desc "Stores Git credentials for Visual Studio Team Services"
  homepage "https://java.visualstudio.com/Docs/tools/gitcredentialmanager"
  url "https://github.com/Microsoft/Git-Credential-Manager-for-Mac-and-Linux/releases/download/git-credential-manager-1.7.1/git-credential-manager-1.7.1.jar"
  sha256 "99afa1079db6de3f3a2edd6efc008ad42b92f9934944491a35bc682c228a1b81"

  bottle :unneeded

  if MacOS.version >= :el_capitan
    depends_on :java => "1.8+"
  else
    depends_on :java => "1.7+"
  end

  def install
    libexec.install "git-credential-manager-#{version}.jar"
    bin.write_jar_script libexec/"git-credential-manager-#{version}.jar", "git-credential-manager"
  end

  test do
    system "#{bin}/git-credential-manager", "version"
  end
end

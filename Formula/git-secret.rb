class GitSecret < Formula
  desc "Bash-tool to store the private data inside a git repo"
  homepage "https://sobolevn.github.io/git-secret/"
  url "https://github.com/sobolevn/git-secret/archive/v0.2.2.tar.gz"
  sha256 "a4672c2d5eca7b5c3b27388060609307b851edc7f7b653e1d21e3e0b328f43f4"
  revision 1
  head "https://github.com/sobolevn/git-secret.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b0a3c3681fddd3da2efca19b917b2bf560a6076361cc35b76e06eb19343aebda" => :high_sierra
    sha256 "b0a3c3681fddd3da2efca19b917b2bf560a6076361cc35b76e06eb19343aebda" => :sierra
    sha256 "b0a3c3681fddd3da2efca19b917b2bf560a6076361cc35b76e06eb19343aebda" => :el_capitan
  end

  depends_on "gnupg" => :recommended

  def install
    system "make", "build"
    system "bash", "utils/install.sh", prefix
  end

  test do
    (testpath/"batch.gpg").write <<~EOS
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    EOS
    begin
      system Formula["gnupg"].opt_bin/"gpg", "--batch", "--gen-key", "batch.gpg"
      system "git", "init"
      system "git", "config", "user.email", "testing@foo.bar"
      system "git", "secret", "init"
      assert_match "testing@foo.bar added", shell_output("git secret tell -m")
      (testpath/"shh.txt").write "Top Secret"
      (testpath/".gitignore").write "shh.txt"
      system "git", "secret", "add", "shh.txt"
      system "git", "secret", "hide"
      assert_predicate testpath/"shh.txt.secret", :exist?
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
    end
  end
end

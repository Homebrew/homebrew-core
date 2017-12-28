class GitSecret < Formula
  desc "Bash-tool to store the private data inside a git repo"
  homepage "https://sobolevn.github.io/git-secret/"
  url "https://github.com/sobolevn/git-secret/archive/v0.2.3.tar.gz"
  sha256 "c821c25865ce7e13a67453debb6d60a8c1730102ecfc4c4b4c4858a02201ab26"
  head "https://github.com/sobolevn/git-secret.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b0a3c3681fddd3da2efca19b917b2bf560a6076361cc35b76e06eb19343aebda" => :high_sierra
    sha256 "b0a3c3681fddd3da2efca19b917b2bf560a6076361cc35b76e06eb19343aebda" => :sierra
    sha256 "b0a3c3681fddd3da2efca19b917b2bf560a6076361cc35b76e06eb19343aebda" => :el_capitan
  end

  depends_on "gawk"
  depends_on "gnupg" => :recommended

  # Upstream PR from 13 Jan 2018 "Make checksum command operating system based"
  patch do
    url "https://github.com/sobolevn/git-secret/pull/127.patch?full_index=1"
    sha256 "0f711bb7f2cd91e0770a92371ea50541aa8ae606c0542c164af7fc280dd956db"
  end

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
      (testpath/".gitignore").append_lines "shh.txt"
      system "git", "secret", "add", "shh.txt"
      system "git", "secret", "hide"
      assert_predicate testpath/"shh.txt.secret", :exist?
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
    end
  end
end

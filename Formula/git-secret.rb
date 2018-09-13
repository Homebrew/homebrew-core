class GitSecret < Formula
  desc "Bash-tool to store the private data inside a git repo"
  homepage "https://sobolevn.github.io/git-secret/"
  head "https://github.com/sobolevn/git-secret.git"

  stable do
    url "https://github.com/sobolevn/git-secret/archive/v0.2.4.tar.gz"
    sha256 "dd9962935f242a94bb00af6a31171de0fdba357171a6c626efc2635751d52bc4"

    # Remove for > 0.2.4
    # Upstream PR from 12 Jun 2018 "Revert 'migrate from bats to bats-core'"
    patch do
      url "https://github.com/sobolevn/git-secret/pull/203.patch?full_index=1"
      sha256 "ee4e263b9725aee59f8b52196d4749a09791dbb4c745a9e81da523d27fcf3f09"
    end
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0fb8db338cf111c40a9ddd2a4d02dcb7779c2f50c88364b118d7cb9442bdfb22" => :mojave
    sha256 "d7a78350338c3f42505215eb1c4d7e48309bf8e5495d1bb91b8517c05ba6398c" => :high_sierra
    sha256 "d7a78350338c3f42505215eb1c4d7e48309bf8e5495d1bb91b8517c05ba6398c" => :sierra
    sha256 "d7a78350338c3f42505215eb1c4d7e48309bf8e5495d1bb91b8517c05ba6398c" => :el_capitan
  end

  depends_on "gawk"
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
      (testpath/".gitignore").append_lines "shh.txt"
      system "git", "secret", "add", "shh.txt"
      system "git", "secret", "hide"
      assert_predicate testpath/"shh.txt.secret", :exist?
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
    end
  end
end

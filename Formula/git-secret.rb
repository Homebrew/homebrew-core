class GitSecret < Formula
  desc "Bash-tool to store the private data inside a git repo"
  homepage "https://sobolevn.github.io/git-secret/"
  head "https://github.com/sobolevn/git-secret.git"

  stable do
    url "https://github.com/sobolevn/git-secret/archive/v0.3.1.tar.gz"
    sha256 "0069650d409488f49ccefcb56d8907ca72d9e360f249d2825eb411cd2228a0cc"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "6ad09e5827dddcc0871374a93ad99e2d90673db21b620ce9a3026fd559912e89" => :mojave
    sha256 "6ad09e5827dddcc0871374a93ad99e2d90673db21b620ce9a3026fd559912e89" => :high_sierra
    sha256 "d01da5731ffddfb9c6d11e1fdb090f8a3625f230088287ed001dccbe1ad9dd8e" => :sierra
  end

  depends_on "gawk"
  depends_on "gnupg"

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

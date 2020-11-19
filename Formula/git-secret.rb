class GitSecret < Formula
  desc "Bash-tool to store the private data inside a git repo"
  homepage "https://sobolevn.github.io/git-secret/"
  license "MIT"
  head "https://github.com/sobolevn/git-secret.git"

  stable do
    url "https://github.com/sobolevn/git-secret/archive/v0.3.3.tar.gz"
    sha256 "d8c19a5cbd174e95484a4233605985dd3b060a8a83d14d41c3bad1d534c6ab39"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4f83446af4efa5d587ae8b0db398fc990eecc7b58be77fdcbc15af53d3ce72a7" => :big_sur
    sha256 "2fb53e4162baa1e614c3d73dbb24257604cf8b7864f73deeba21c784c6434193" => :catalina
    sha256 "2fb53e4162baa1e614c3d73dbb24257604cf8b7864f73deeba21c784c6434193" => :mojave
    sha256 "2fb53e4162baa1e614c3d73dbb24257604cf8b7864f73deeba21c784c6434193" => :high_sierra
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

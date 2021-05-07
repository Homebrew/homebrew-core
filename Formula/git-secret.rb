class GitSecret < Formula
  desc "Bash-tool to store the private data inside a git repo"
  homepage "https://git-secret.io"
  license "MIT"
  head "https://github.com/sobolevn/git-secret.git"

  stable do
    url "https://github.com/sobolevn/git-secret/archive/v0.4.0.tar.gz"
    sha256 "ae17bfda88eb77e8f07c5f16d833792a3a14adc9c5d2bbc840f28538c62f08ba"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ec659e8eeebebff9eede384309558a94117185e9274699225da85762df656552"
    sha256 cellar: :any_skip_relocation, big_sur:       "798cb8d91b23ac5ad8f8c4b2b74ddb2b531b4f6e3302d846f99f673b46558889"
    sha256 cellar: :any_skip_relocation, catalina:      "5680327a70bdc617206c09148e3c7107b10c1069fb31ef705369399c5ce09f8c"
    sha256 cellar: :any_skip_relocation, mojave:        "39e2b5c3a4310bd28780e90d36f9a1efeff8f7397364306747416c3cef8faeba"
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

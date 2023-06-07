class GitSecret < Formula
  desc "Bash-tool to store the private data inside a git repo"
  homepage "https://git-secret.io"
  license "MIT"
  head "https://github.com/sobolevn/git-secret.git", branch: "master"

  stable do
    url "https://github.com/sobolevn/git-secret/archive/v0.5.0.tar.gz"
    sha256 "1cba04a59c8109389079b479c1bf5719b595e799680e10d35ce9aa091cb752af"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8486273b279e327dbc528a12e760f5cdd8753e8b8bc45a2a1ab54eaeb6873f8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8486273b279e327dbc528a12e760f5cdd8753e8b8bc45a2a1ab54eaeb6873f8c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8486273b279e327dbc528a12e760f5cdd8753e8b8bc45a2a1ab54eaeb6873f8c"
    sha256 cellar: :any_skip_relocation, ventura:        "973f4fddf023508c20a21b6d4cdc303c24d7bdd8d912c7ba90beee9d71aae329"
    sha256 cellar: :any_skip_relocation, monterey:       "973f4fddf023508c20a21b6d4cdc303c24d7bdd8d912c7ba90beee9d71aae329"
    sha256 cellar: :any_skip_relocation, big_sur:        "973f4fddf023508c20a21b6d4cdc303c24d7bdd8d912c7ba90beee9d71aae329"
    sha256 cellar: :any_skip_relocation, catalina:       "973f4fddf023508c20a21b6d4cdc303c24d7bdd8d912c7ba90beee9d71aae329"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8486273b279e327dbc528a12e760f5cdd8753e8b8bc45a2a1ab54eaeb6873f8c"
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

class GitSecret < Formula
  desc "Bash-tool to store the private data inside a git repo"
  homepage "https://sobolevn.me/git-secret"
  url "https://github.com/sobolevn/git-secret/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "1cba04a59c8109389079b479c1bf5719b595e799680e10d35ce9aa091cb752af"
  license "MIT"
  head "https://github.com/sobolevn/git-secret.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "3d07ffe72c061cfdb5b4264cd54023d58454b18dcdd01f8e6367f5110d8e96d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "312e53ea34e56c911631589636df17f4f8cd00488f4dd1f8eee19896d588ec25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3229d4fb0a2237d1d4594b7e65706f68bc0d434e7d5e6d2b7ba445b1c6155c55"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8486273b279e327dbc528a12e760f5cdd8753e8b8bc45a2a1ab54eaeb6873f8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8486273b279e327dbc528a12e760f5cdd8753e8b8bc45a2a1ab54eaeb6873f8c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8486273b279e327dbc528a12e760f5cdd8753e8b8bc45a2a1ab54eaeb6873f8c"
    sha256 cellar: :any_skip_relocation, sonoma:         "5291bc2835a8fe2986e6dfd7e96ac1632ded49599b46fb7c79868d2406f08812"
    sha256 cellar: :any_skip_relocation, ventura:        "973f4fddf023508c20a21b6d4cdc303c24d7bdd8d912c7ba90beee9d71aae329"
    sha256 cellar: :any_skip_relocation, monterey:       "973f4fddf023508c20a21b6d4cdc303c24d7bdd8d912c7ba90beee9d71aae329"
    sha256 cellar: :any_skip_relocation, big_sur:        "973f4fddf023508c20a21b6d4cdc303c24d7bdd8d912c7ba90beee9d71aae329"
    sha256 cellar: :any_skip_relocation, catalina:       "973f4fddf023508c20a21b6d4cdc303c24d7bdd8d912c7ba90beee9d71aae329"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "fb056265e4393d5c8e553cbdc671c5b046c59c13ba10ff6e00d512179b29421c"
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
      assert_path_exists testpath/"shh.txt.secret"
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
    end
  end
end

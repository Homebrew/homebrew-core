class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.14.9/gopass-1.14.9.tar.gz"
  sha256 "71f1c95f411c074cda75ed22126e4d1f81a746591f39bbcf2de369603978b52a"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31fd1e08a85872fd4409cc2be3026c930ecc2470be56ec1a996c346b4d4a7cee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2459f79e014091f84edb9f2f1357a825fb020175c47061a675af2d95ca8cad72"
    sha256 cellar: :any_skip_relocation, monterey:       "c54514a7cb92b2677023e1ac56eb65e0e491b36a6d47fdb1cf3b334efd8f4e11"
    sha256 cellar: :any_skip_relocation, big_sur:        "336982d9152078ed7ef35e04180c1ea874cd8279f130d32037562c7533c26ef7"
    sha256 cellar: :any_skip_relocation, catalina:       "f76ea3ae9ec5a0fe48e2499670f4dec8cd3f2ec8b932fb0ef0f15da7660459bf"
  end

  depends_on "go" => :build
  depends_on "gnupg"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}/"

    bash_completion.install "bash.completion" => "gopass.bash"
    fish_completion.install "fish.completion" => "gopass.fish"
    zsh_completion.install "zsh.completion" => "_gopass"
    man1.install "gopass.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gopass version")

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

      system bin/"gopass", "init", "--path", testpath, "noop", "testing@foo.bar"
      system bin/"gopass", "generate", "Email/other@foo.bar", "15"
      assert_predicate testpath/"Email/other@foo.bar.gpg", :exist?
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
      system Formula["gnupg"].opt_bin/"gpgconf", "--homedir", "keyrings/live",
                                                 "--kill", "gpg-agent"
    end
  end
end

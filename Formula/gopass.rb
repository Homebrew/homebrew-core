class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.14.9/gopass-1.14.9.tar.gz"
  sha256 "71f1c95f411c074cda75ed22126e4d1f81a746591f39bbcf2de369603978b52a"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5383edfa7e8c9ef43c0b610bf66703231176061393b9f8ee43677e060e502982"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5157572ddaaee646e0f683d3836588b6740003794af914358ca39cfebd57d5db"
    sha256 cellar: :any_skip_relocation, monterey:       "c6b558a205fd9cb85f6bf2f3a8ec20af8f208f286a3be0dbdca058640313b36c"
    sha256 cellar: :any_skip_relocation, big_sur:        "31462ebdef4885f2104e9cdc864cb298dfee95ab579976c2f75c4a63fca106fa"
    sha256 cellar: :any_skip_relocation, catalina:       "d1e6082f55e5f09ddbd4d44b30d81ed7a779e4239b40fb5eb8d902c195775bc0"
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

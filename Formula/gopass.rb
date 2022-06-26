class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.14.3/gopass-1.14.3.tar.gz"
  sha256 "93896ed1011dc154cc8c4bbc47d34be945af4e7e4358df6ead4472639ca900f2"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b44d63921f5d48b51ae796508418fca9614662943a1eba49c7a3fff2a301e462"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "843554c426af3c6f590faf9bcb6bd39e7148faf8df00887be0cbd8ca8936405c"
    sha256 cellar: :any_skip_relocation, monterey:       "5970d47a6ad41c3bd7c9d70bad3f4d73803d1cb9d6b0c050a6639809a0799f55"
    sha256 cellar: :any_skip_relocation, big_sur:        "67118d882bec0e9414c7bdcfdb582bcad0a7b7910e1e78c61fcc85a578a84c3d"
    sha256 cellar: :any_skip_relocation, catalina:       "45d82ab54704b94d7229c4a419dfbdba543c2ddd7a087a6f4e6076af4ab1b137"
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

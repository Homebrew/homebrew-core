class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.15.8/gopass-1.15.8.tar.gz"
  sha256 "cbab66e5f7fd160711b690e267c61904e98b2cd6bb8d7dc1091df895ad071e35"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d42477f75c5ee9b3f68878511bf25ab1d5c23c3ace285ced604267cc2d7bf95e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47a3886dce320d52f82983091aeb0a0af83601a47b2031be060184a955c5f6a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6839fa0bbda8b1b290f3caa9b351b7566b89d35ef4e5d3fb2730cd2efcb286d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "083e918dc80fee3151cde816aaf7247353c88d8f5553758fb97aff4b5a0812a2"
    sha256 cellar: :any_skip_relocation, ventura:        "810db507d9ab0a3511e2770b33d6ed8491ec2a8a196d814407135cfe7eeca018"
    sha256 cellar: :any_skip_relocation, monterey:       "c6050892133f9283b0d45bda0c2f3ea50a7872d573a21ef3f5376cbfc49673c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c20eea1f055ee848bc1df21b0d21b0d5f974962bc3e0c39f0d977a1a4e76ad7"
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

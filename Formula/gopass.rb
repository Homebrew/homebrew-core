class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.14.6/gopass-1.14.6.tar.gz"
  sha256 "ac1707a6043336f14b08c1e0add2d970ff8b07885fdf105b8497001f47046651"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1b03e6f12b3716217bc59d58ef22970cc5375a3b7e93f0111266c3555868858"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ef2c2a5dae6fb7d5ec1fd2b2eecaf8e28480666b5ea44cbb161d11aa502276e"
    sha256 cellar: :any_skip_relocation, monterey:       "ef7f839cd7a82e72af37d7f4d743c73f8c146f1dca53f82a0c7129a09945b1f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "08c1b5d8e03ad32ed4e125016252c0af0524edb7011b82551c318ceba0632dcf"
    sha256 cellar: :any_skip_relocation, catalina:       "77c8da201ac6ea530a8bbf3b0a41d2ccf97da6a99f630b809947b66462dd3a3d"
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

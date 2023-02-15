class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.15.4/gopass-1.15.4.tar.gz"
  sha256 "6f94c935c2f5b31b2c00dc44302be6026ae5fdd4f6fb390b5fba2f5740667100"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f74c3fa4a884025fae11b110c0686e4c904a4ae0d9cf58b6e645dd52880947fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fda15d8e25545f2bc18fea7120f3fb12a35116c77f25e4793a6d46bcfe3de90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48d4d65e3d429275763789e495751824a4b2ac0cde87dc3fe42eefb884269892"
    sha256 cellar: :any_skip_relocation, ventura:        "513fdfca784860b40a2259a6f49651f1a351c5e587fc2c6ede8fe7d32ded6e33"
    sha256 cellar: :any_skip_relocation, monterey:       "c97f7ab136538b9619f64c9731af044c93cf1e6ca0eddb30835477a938365009"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed28cf287911fd7004d827e72c1be09fa5e101daa89bf683d0df248f35cb8ece"
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

class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.14.8/gopass-1.14.8.tar.gz"
  sha256 "301c74d2b5ddf04ec19b196ddcb99cf8d1e11ad1d6b68df9e322d0576c6c4245"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eccbc371d0332a7341c9c2b9bf235b71489d948ff0fe9e77f5b93efc84f405e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7195ba9345d98f2760e242043d9a8cbec0856c2ee9a9f30bebe546ed9753071"
    sha256 cellar: :any_skip_relocation, monterey:       "df308705b46e4ddd5ac19c1c104c8383d1bf181e2ef64433b3d435c1a8c3559e"
    sha256 cellar: :any_skip_relocation, big_sur:        "70469db4541279f1e08cd0f78a7b9a60a3b65b81df29e3d4f28b183b28d5d1fe"
    sha256 cellar: :any_skip_relocation, catalina:       "0427539ce2050bd25da31d91bfd2b606d7a4635b7ed336387381245f12a7421a"
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

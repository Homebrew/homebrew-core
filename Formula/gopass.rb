class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.14.7/gopass-1.14.7.tar.gz"
  sha256 "443de8190da2913033fe0a18ac0aee41155a9f004a6f608675c99de850a9e03b"
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
    bash_completion.install share/"bash-completion/completions/gopass"
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

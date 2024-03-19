class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.15.12/gopass-1.15.12.tar.gz"
  sha256 "b4421c5f583a98aa257e9b1a7c192f91a766e65e8778208174328ad8075d1348"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0939d9ff84338c4185145456713aaf9b6a70d4fff950ad10cf82c54277e2eb62"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ec9289bd58819b8986a5523549707bec19fb262f4459f006f2404e5e4522cfc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae8fb08577f6b73c87fbdac365230cf8afd5ec8ffe46698618e98cd4d75e136b"
    sha256 cellar: :any_skip_relocation, sonoma:         "cadc8540493fd27c0d45f6189964e5540f28f81c834fba648b4cb61d9f722d02"
    sha256 cellar: :any_skip_relocation, ventura:        "619d5c7a6729c7a385554054abe33f7ca05e6bdfdaedb0b199d8e26aa2164140"
    sha256 cellar: :any_skip_relocation, monterey:       "49517c7e39f6113900cf1ceb9b61290469b7c6256b33969471b686d79d6508f3"
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

class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://www.gopass.pw/"
  url "https://github.com/gopasspw/gopass/releases/download/v1.15.18/gopass-1.15.18.tar.gz"
  sha256 "e7773bf5e6a51075d84c656525fa53228dde401dd33e5636fdd5ec9b896fcdf6"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1956c5c00b9236ba5fc1181605d8a9ee99287666ab152f8771e5fde55aba0803"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68e9291f7bd9e370fdea3dc7fcfcbcd25402ec89e4657e1e7acbd90417ecc995"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df9a5607bdb7d082eb3d81a432b4baf269fd430bb77cab722d213b2be706f10a"
    sha256 cellar: :any_skip_relocation, sonoma:        "42335fb79e36bba939cb8de30f919a42986bb5ace1be936defb89fb8a4f98b8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e801ce04563bb5df719d76b22d4afff87e3fca76a58aeb66ff89cb0de73a1c65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62517a73c4013200394deb38a2c80d727ebd808bb61d3683ecd6ee9fc9e94fb9"
  end

  depends_on "go" => :build
  depends_on "gnupg"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    args = ["PREFIX=#{prefix}/"]
    # Build without -buildmode=pie to avoid patchelf.rb corrupting binary
    args << "BUILDFLAGS=$(BUILDFLAGS_NOPIE)" if OS.linux?

    system "make", "install", *args

    bash_completion.install "bash.completion" => "gopass"
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
      assert_path_exists testpath/"Email/other@foo.bar.gpg"
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
      system Formula["gnupg"].opt_bin/"gpgconf", "--homedir", "keyrings/live",
                                                 "--kill", "gpg-agent"
    end
  end
end

class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://www.gopass.pw/"
  url "https://github.com/gopasspw/gopass/releases/download/v1.16.1/gopass-1.16.1.tar.gz"
  sha256 "7c4a9bf398a9bdbc97a88a76890d129aa04be27604ea8079cb6f9b46033a0346"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb2a3e09abbd49e3f9fdd82d2ec5d2f7fa748513069166b4cab95b298b6a6487"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85d36c653824ef7686758e1ae3da83e2016b309bfac275e34920d45818b90259"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cd62aa8cda0a1d0f1ff64bbdd59b3e6705cf9fc9bbbca1dc5e2168c139cc1e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c7d3f36b624e00966837507ffbf45067b8b5749c91e2c158498b808c80f9fb98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c2a02afd35b2159a0621849778470bf7e1a697b8fcb52205b103c526f6cb34b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73de39c67865423e1bc107f39f995d297405448a3f97b7cb5ac8b419c70dfebc"
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

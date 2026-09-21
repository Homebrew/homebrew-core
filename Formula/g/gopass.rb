class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://www.gopass.pw/"
  url "https://github.com/gopasspw/gopass/releases/download/v1.17.2/gopass-1.17.2.tar.gz"
  sha256 "e338e6e45a8482db4dfc9ead2bb9ef0ba5be093ef813eaa64c4a5d34354ef002"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "57ed746d3dea5fac86b498cd9b4e59c3183c2085a96f3a3485308848cbe63d0d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c3f41e21c59631a152247b7ea5a366d3e3f4dcf3a0c180d4606321827cd69a00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c7ec1de3342eab9021d975374a9e479714b1d050ee654d67176082602d63dc45"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "cecf2457e6e843da4f033c3a147df1bdc03a5c52a36ec9627f3809906ee3fc43"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bdf4c7030a7a7a772dacbdbbfe995beb2b69eaf31863adc411b97b773cba1251"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "484a766eeff405e914cb78ba4d8b2bd733e27e3d56c79b3592b084e4c0f449ce"
  end

  depends_on "go" => :build
  depends_on "gnupg"

  on_macos do
    depends_on "terminal-notifier"
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
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

    (testpath/"batch.gpg").write <<~GPG
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    GPG
    begin
      system formula_opt_bin("gnupg")/"gpg", "--batch", "--gen-key", "batch.gpg"

      system bin/"gopass", "init", "--path", testpath, "noop", "testing@foo.bar"
      system bin/"gopass", "generate", "Email/other@foo.bar", "15"
      assert_path_exists testpath/"Email/other@foo.bar.gpg"
    ensure
      system formula_opt_bin("gnupg")/"gpgconf", "--kill", "gpg-agent"
      system formula_opt_bin("gnupg")/"gpgconf", "--homedir", "keyrings/live",
                                                 "--kill", "gpg-agent"
    end
  end
end

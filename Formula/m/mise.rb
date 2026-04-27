class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.4.23.tar.gz"
  sha256 "8a2ef260b61f310f402fc8a14112973d3f5108afe33cd3102ff78d8bd5f1be7a"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de420e6e1f21782e763090e4d409fa0121e7cbb5408b08ad9fbe5ac81c4bec5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d895d16b021eba0d753e070eb7e63addbbd6a1a0fe97ca79077c3739dc44c60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c8c7a212a2cbe00679cb591e20944be8d6b03ffecd615dee7045c357f6cf976"
    sha256 cellar: :any_skip_relocation, sonoma:        "20f320635dee45dfa56ac956f70b1652bc1807b74a757887fbd765b9582a1edf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83de3ef6572ccf09d1d8eab25717008005fb89f729a0ea676b96df81311e237c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3740be8137b7d28b439bf3ef8893eb563a541c293d5345eb55e85edc3966e850"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "usage"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix

    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/mise.1"
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish/vendor_conf.d/mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/mise activate fish | source
      end
    FISH

    # Untrusted config path problem, `generate_completions_from_executable` is not usable
    bash_completion.install "completions/mise.bash" => "mise"
    fish_completion.install "completions/mise.fish"
    zsh_completion.install "completions/_mise"
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system bin/"mise", "settings", "set", "experimental", "true"
    system bin/"mise", "use", "go@1.23"
    assert_match "1.23", shell_output("#{bin}/mise exec -- go version")
  end
end

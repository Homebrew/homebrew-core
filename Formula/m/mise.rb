class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.11.7.tar.gz"
  sha256 "665e8d8a4b6ee40e82e8db9d69420fda0930911e7aa712f7b590d1f6baa0375a"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "332edcaa55e83277c938386141ae6162d97a9e4b59178d7db6702eccfa63dca9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fdbd12c13083dd03aa9de6699fe019708477e008e537d6cd22a99c4eafbaf970"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "81939fa13549d4d7e5572f02f1058f572073abae285c1ec79ef8db0cd6bd7077"
    sha256 cellar: :any,                 arm64_linux:       "dc8c62adc6d58c71d287f3cfc888ec785b09f64218aabbf0a1076c8d6433e336"
    sha256 cellar: :any,                 x86_64_linux:      "ffe95ac233b5550c7052519dabbcf16c454d1440c1ad66888adc94f8d7027e01"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
  end

  # downloads crates during install and binaries in the test
  deny_network_access! :postinstall

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?

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

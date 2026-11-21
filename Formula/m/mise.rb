class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.11.12.tar.gz"
  sha256 "5b20b1175cb3b8396c08fa216abdeb2f3b447794be6750d99fd0badec0a24c75"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "23a930c4afb0f14d2cd7efc5000d502c6131e57a7071c20568f8dc9ad7e3160a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1aa1a5954ef826c2351872f094832acb5832c62baa5573ea5e10d2fe0494545f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f2b43f24a32bc3b0e7b308c6d07744b0ce59c7df01207c9cc4d3b0bc2af17cbb"
    sha256 cellar: :any,                 arm64_linux:       "dd269b47edb2031c5c44c2f6622fb071325e0d550f2b59c851336936a1ebec75"
    sha256 cellar: :any,                 x86_64_linux:      "d39ed451fa980aa44a0ce963b1410e2fc036f3a936624fe5e7c3db97f8c69b48"
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

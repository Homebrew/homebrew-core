class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.11.1.tar.gz"
  sha256 "1ac4b33d9c0a2daec259e6a803dfc26c5033c06721fc639b5e9fff5ff03bc4fc"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e44c9401c98da7d6798f2e9189ee4549be9d4e67a720e1e19015adae29926233"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "afc4653dc6dbd94e612b4cd37e1ffce5ef252196b17032b0e04047f66078619b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c2f1392b4040975c03fe943c5cba4bbb70ae992f22c4edf75667540337544fa8"
    sha256 cellar: :any,                 arm64_linux:       "9d3383ce8abe0b1e45a77338cbf5b0117d94d023dabad5cff171330e4e0a31ca"
    sha256 cellar: :any,                 x86_64_linux:      "36b8f793a0bb3b24df8fc444422739aa58f5f30280fcdb645acf06c239236300"
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

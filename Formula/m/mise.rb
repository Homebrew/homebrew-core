class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.11.10.tar.gz"
  sha256 "46a75ec4b9d474fd292501129f1ead99502c44a17103f97677463a57eb623e52"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "380e2c26e475e0d5ef82dfaef8ccf5f4949ed3edafe2cbd8f946d77421b6f09e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "049fa95b1dc3962a43c9847902fbbf7e8665bed7ad1543f1e2cff9ed64a6065b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "574779c8492329f46a20d6d85eb15c3d5a3d2524c469bea99553cc090e37b4e7"
    sha256 cellar: :any,                 arm64_linux:       "e5c4bbc11c26fab3614b9c7c65ab5977650906b2ad43753ed4f04b8f3456f6d2"
    sha256 cellar: :any,                 x86_64_linux:      "2bbbf3f248225df540659fdd328a3d826798cc384d4bcb84977ebeb5669b654d"
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

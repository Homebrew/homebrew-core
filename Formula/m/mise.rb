class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.10.17.tar.gz"
  sha256 "3b9cf6be9d57d342ba8992a11aca19dabc91f390b3be9f570d16d4d055b471c9"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "876d23780a8aef6fdff9d6430575474ffc5fe6aab1125f75c55b2d6a584bb691"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "108a8b0e7cbed7b75391381eef9817dad49ca6368843f72352c31325826f1bd5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "26aa708e3b40aa7fc9329af0d768cade507a5c8165ec6d2040fae6e270265831"
    sha256 cellar: :any,                 arm64_linux:       "44b9e915c5a63feaa42a6ef3c2a11c067216b122e50788e9b36f3a3475886f50"
    sha256 cellar: :any,                 x86_64_linux:      "6e032436d3ca1be0b11b0805d7cdddd3f3a2f67064b48d8c8e4b6a7b90e64563"
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

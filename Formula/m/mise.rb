class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.1.2.tar.gz"
  sha256 "fbd11a1f2395339aa5243aca7e323fca6ebe6982dce8349fb03a3005c6ffd2f6"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa63cd055350235959c9273a3431bfd00c4083850903aec9b496d5332ee50ddc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6bfa12eb7c5bc0713f0b05a049886df6e045d2e51ced2ab062a5b59229423f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90c85fc5fcc5305eac2b3db0951de3cacb587f4357d311ca27b8a0fe30eff088"
    sha256 cellar: :any_skip_relocation, sonoma:        "71dcc3f0845243cc9d3f527e728bf244937e11d3a4b0899f7230c19ccb424c27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1a111227e3ed574d925475aba0871380c45dc960b2446a8c4c5eae47bdb6cb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc6955f032399b7468c227972265633f9f1365cd9dd242b870444664733df7c6"
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
    ENV["OPENSSL_NO_VENDOR"] = "1"

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

class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.7.3.tar.gz"
  sha256 "05a81b2e03465417cac0b588c3d9b9ed2933c823519f71e1e6238fd9c00b929d"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b6bd520eadd16ad8f2b8565188d0e77ba176da51c311ad5926508e22a267767"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "111be0cca89591f23359ae2655a3f4cc5731eed5c705d46c589cf8ccbba56153"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b89bb69a3fd64461c068c7fddff230f808695b730943a01122eb4d2d6e6c7cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "de295e7f1063d890ed175ea2f8111a23fb2640796bf24b662bdad1df0a8a56ad"
    sha256 cellar: :any,                 arm64_linux:   "f4df088ed2c117bd946867329663621c5c7c86901201b568e726997e35b346c7"
    sha256 cellar: :any,                 x86_64_linux:  "d6fbf5c5e512e7e53ea281c4e673643a60a4bd3d0b08840c5801cbcce8756243"
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
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

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

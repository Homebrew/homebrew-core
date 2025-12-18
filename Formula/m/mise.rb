class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.12.11.tar.gz"
  sha256 "7298b243d7d9addf8f3ab265234294ee61fce4794c206bd3dc65a7233c26b520"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "787fa9fcc56fc52e93354325d609dfb52b434d695e0ee288283d1ea2ababb08a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afc268cf05717ef01e28ffd2eacd922d8b3201f96c8af338c1476e57c98d38df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2218482b978f465a705044356136b0fb0af8ca9bc2829c114851699c3158742"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba8e00b0019ecc5fc43b39f5e121df5d50338d6cb07efac66f3fb6d2ac3ce1f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d141ae09f4f09a80bd95997a38cd47373b851ba29e79e2c3278c9b82830f36b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b49cc5dcbe642a10727454482655a25dd16b988cf634b5f129556c8c27c7d497"
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

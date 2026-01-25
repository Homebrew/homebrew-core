class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.1.7.tar.gz"
  sha256 "595b53da566e2dce5d46bc2606755a1831dc5fc464d884dbf606337da1685543"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5bc75dc3594a07ed9b420471773a4d941fba4fc09de8fce5762f0a1f5c43c7eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12c6701cf9ef33af5235da28ef615828b130afd8867284a61ffa7d1c179eace9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5042e5f1c15e2165db4efe7cd032cd3dd40521b0511cbd3fc4ca63cf33cc355"
    sha256 cellar: :any_skip_relocation, sonoma:        "38aa88338028bed352d5dd436d79fc7551dd513c33a4d5653e9a098ce1727ca8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5dec31ed153cce271ba5d1da4f700e0e7a393ece983f52139943e847bf61a0b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "417525ba8c688b6bb4a17610e052d4c9cf663daa022eb0851861527b64e15970"
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

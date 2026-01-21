class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.1.5.tar.gz"
  sha256 "5befbcc8c9867a9bb639ee271aaa90e8a1afa56707c6413ec7ecc0c25e8d78f9"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e92d8bcdc922ca7ddacd379e9a94cce8e4848db553e1fc133c1f2522667cdd6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0603f9ca75728b22fa58046d8d64fddb565b249ba7c50433fddc95de72a73fc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1781ffa7f8847e249589b9a481e16beec5352bbd5fc19458ab1f331ab877ee7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c539b1bb916edc1b9fc9410adfc0b8cc0f0f69a51349ce98706ce30bfb162009"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f077bd700d1cc7e69c04a2bc1a6207160f22ffc8cbfed821c009785e0c08d6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9147473b9aef2332ab61a790938e5b31e485049bb6e62f4770f53f9cda3bea78"
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

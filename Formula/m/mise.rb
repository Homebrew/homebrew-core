class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.6.1.tar.gz"
  sha256 "05bd9f110b656a786554ad103e2a82012e51b75d66756dad429f0a8bd3dc63d6"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1221acd40525f9afd4034465d5e78f832a986c0609c770d5e688234d77198e45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91dc355f7609c9ad371683fbdc3ca48120598e312f333d89b88488f0819c6e36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9de06ba5ebea5caa3011e847d2e5c9c8c9d93ae39f713e9ada081e602059d348"
    sha256 cellar: :any_skip_relocation, sonoma:        "66da3ca8b252141def3ed0c2493c3c7faec09e955b5b69aa072fbcda3c885f5b"
    sha256 cellar: :any,                 arm64_linux:   "4516fb5b684070da9ddc318e4d56d32f6c5ab4b27a4cfbae87ae5ff9cd144132"
    sha256 cellar: :any,                 x86_64_linux:  "7bdd52985648f73c6bddadde2002c90ea67910bbe3cc9e9095817944205db549"
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

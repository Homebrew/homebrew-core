class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.4.11.tar.gz"
  sha256 "a847ca56d6db11571cbf54611156e8d18e0e31f2e63bd9a59fd575af524f2f03"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80a511c619c2f96abf9c8582a24cce908c8fe5c0944078e06f343051f62f8434"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bc35a901f489535fdb96012eb09b642dcf897c24f1354fb64676410504db9a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "995baa47a38c1660f6467519e98901d651530fd95f6c49f650efed4f9cb2413e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f888332b7c17423a7d765972bd8509a7f95d60260c068caf32e374653833804"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af7e50c5615be7b114c3e34053cec453d643a07771482c461c4e9bc6a7aebe8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c787d3035d3813052637eee1d555c3e56af91a7d6aac5e969f5f8139d51038d3"
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

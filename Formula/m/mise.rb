class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.7.12.tar.gz"
  sha256 "bcb84bbdfd942ce3d808ea844d2db1021f017de810a3d67f8c99ec0df51a719a"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b71075922bf253c66dae3e7d3281a9cafbc338fb6e237c7d3dac3223930bb4bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "404d8ecab48a94e46d08df1d90de0eacdad3f26ebeef741f8feb6c7e04bf4688"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "495de8193d0b0bc15f2b2fbf999853c74c0c42f1fa019c5c5b185a01782c8131"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bac35ac305c98cff66fa833025636c0b1b85c64ad4aa3e5e4b61c40227e65d5"
    sha256 cellar: :any,                 arm64_linux:   "17b88170a0599bd157e38b32dcbe2bf81208f7df4873e87af516815027bf50f4"
    sha256 cellar: :any,                 x86_64_linux:  "be759ff58f38d720eb222510657e0c603cb9de0ffc9463c11613208a843d1454"
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

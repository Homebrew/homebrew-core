class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.5.3.tar.gz"
  sha256 "a40b3ecc7f3b92de703f016ade49f250fb9a280d48a0aae0bfab608bb0c48b98"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a79d320f4ec84d555302a06474488754f6a37fa6a438609b2824b7d565d37a0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a49cfb7fa8dacfec01a67dae99a463fa63c8db508c707adcdfb8c141c743b0e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "581aa16334408132bb40c8f1c4193fc2ef584090c96877789c023c11355a302b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8918e03a62babe82f77c6b5e60c3465d7328407d6a994138555c1d0c6cf6d8de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47d5d79e5e1ce9d0e7a5d677a88cafa70a89e4fd4802bf008215499d4a4dd12a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35440a61803a6eefee4e650eda3aeb192ec4e179267d1241561cf9eaf607ca93"
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

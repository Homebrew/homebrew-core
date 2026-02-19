class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.2.16.tar.gz"
  sha256 "38eb0b384d1fe972008cfe6a24fd2810a9c42f06b0598fb4172b97af9902594b"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "789d857151c0bbb39d2fc28e378cc477e32baff3267d7c6032b212f0164cce97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "936746ab574f295bc693cbbc5330d004b5eced2ced786aa25379c043b04f07a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0a7f3b0fdc41fd96d3ec505785c6d84e0eb7d605698beca8b9eb3b7b55da450"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c5444b8f928e257d43e2bce532794520712888aebbffb891f56e45818c2c879"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d37a85f4a156bd448f70953ea2b80280034836183c1989fc0aa4b56e67c2de87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "416e64f3dac0cd4ce686689935659de027ef1c8d0179b951409b9380a93da323"
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

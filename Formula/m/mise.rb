class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.11.7.tar.gz"
  sha256 "16df31d697a54eca7a7d7572835fdcbadb390f240705d829327d38783b236650"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c714c0b9808234aec49789ed56b163c69b75ce37404cea6065d9c745c26a7a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48bbb05ddf09762e5941473a58aaf48a8a368518e303b7b64852ebd84ea5e240"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de4f8dd3471f8cd327c36da99647c9bdbec2a50a8ff16633537f1c39aee93b8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "99cbee6edf6de8ef14d57625d6caed91a30dcfe6adbeb00d5a3997c61e5d9ae1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26b1f8a6ed757f2c731ca913476697e466f27ccacf099f24ff06363c52a2a43c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a185ef8d2c20368fb1be4da2e19d008fc54eae50e1b9bc2af244601d973d87d6"
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

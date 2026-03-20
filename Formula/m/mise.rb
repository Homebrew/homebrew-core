class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.3.9.tar.gz"
  sha256 "f179793bf20b4307b26468f45b1c446bf4a79d1aa822217e82b4bbcd5a6c0118"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac604f45becdcdd5b44be22a24e1f055861d80af651660ca65508c0a85f0f28b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b0786987e9060c3f8a9cc110ac36c1e3e87492e677274a9e9f5e16b5bdf4087"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91a18fdbd16f1572dc6dcf1e4264774164cc0930feceb61fd0c1e8d7c9dfd95b"
    sha256 cellar: :any_skip_relocation, sonoma:        "45591ee2f9fec160f0445c1c99b1f7ca55a42519baddb2aeb7d580eda765bc26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e265a93185234be703ee8890389755beef7aba7232b9a247ad6ff4deb54c2cdb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13a2ec3aaca5b2a2e017cf67eec829874a2f5d8185acd27e11252b24cc06d3a5"
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

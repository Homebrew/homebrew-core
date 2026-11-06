class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.11.3.tar.gz"
  sha256 "bb886d67e4169f1d01b691a584dfa570fbfb530cf8db8d34501027d26398cf1d"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b56d611f996d06bf2f2de9c70f59ceb963887d60e5577386e13a87a80d0b56ec"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9c3f2fc3d80c3c61f2f642d2bea4f0800eb003ad405ba1963b7e02b17a286e1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "21c85f468530682307245157746ea835441f4eb69fcf81865e556507180b9eb1"
    sha256 cellar: :any,                 arm64_linux:       "12f1539638128466d360440e26644758ad37d8748e62f577024d010583cc8d47"
    sha256 cellar: :any,                 x86_64_linux:      "5b068e7bcbd62833db7cad1439de84fea6903557d9af79780b14eae529597920"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@4"
  end

  # downloads crates during install and binaries in the test
  deny_network_access! :postinstall

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?

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

class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.11.9.tar.gz"
  sha256 "0dd2fd42fddc636fae0ce8cb1344e0beaee1cbbd8c568cf35d6e0654335b4b7c"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "89b85e1a7056203786641761810f922ada7697def8d2db384d0cdf5ec901dcee"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1d65267dc1a21af42c52ad8e1e735b1c6afc9343d2236111ae85121602541fac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9503bbe47fbcddfed8f41f54a02c247fd2efb158b0417f7808ab514520e86a0c"
    sha256 cellar: :any,                 arm64_linux:       "fb9c7133dbddf801b051d5bb59426c4de89054790595ea91fcdb541b1a62c705"
    sha256 cellar: :any,                 x86_64_linux:      "866a9ba78bc3c6357b722a054b87b6f0200f1043a2faeb0beb21087075f0e496"
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

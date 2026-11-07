class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.11.4.tar.gz"
  sha256 "c3537e2f2be1f0a5b7df6392393a3508309fae1db458176e7540e3f48b1f3e92"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "20ffec58a7f3e87b4637c14256cd4eb654503459e99943959b67889ac1ee9f48"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2453eb79eb79c63ddd371ff9697cf58512459b4e491171586f038e2b2e9c89da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ade659078cc5140fae37874d83577b78249fc4b4003c8a17050bb5422e29baae"
    sha256 cellar: :any,                 arm64_linux:       "9a25f289400f05f65e477c9e504db5e40f4696d5cdd3b414649e814af31d979b"
    sha256 cellar: :any,                 x86_64_linux:      "5f69ff6b1506be7cec024371761e12134a660f7cc0248003ee6999c88e00a94b"
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

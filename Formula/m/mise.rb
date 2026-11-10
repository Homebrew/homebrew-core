class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.11.6.tar.gz"
  sha256 "516d03c4a9b35d2c7e221a33d1318130c3ee9bfcb4d7e07ec0cd2ed991f50c5c"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3a34977ada7c562a6b08d58329028aadcbbd34df35c00e7cbf0651f69e45e865"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "531dcb009f18e16bd9371f7bf4d08af3b329d0129a42fa9ba2a417262d3071af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ece97f300665cf7295217be562b776f94720a1792ace3b0aae7a403c8e735bac"
    sha256 cellar: :any,                 arm64_linux:       "91be298a964e7d936cc9f845dd3ecc109f61e995fdb47601bf9b741a9e12a1bf"
    sha256 cellar: :any,                 x86_64_linux:      "2f3f44dbda077bd130eb54cdf0a69bab6961e6e202e49b95d1d761ee9ffbc9d0"
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

class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.9.12.tar.gz"
  sha256 "6d708b6c6f676a86c81f82506a4911517fe9574775cb734abd0c4c739efdca47"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c97442e27a105917722a557941b14218d56af5ac2db69b0e2f602eb34b11731d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a62c1eebafc455a9da3fecacaa964119c9b7ea678ea36aeb8f780b87dd726a2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5355b066b93eed1f330e7b139f064012d32e070d8e4dbd75c83a0beaea1821e5"
    sha256 cellar: :any,                 arm64_linux:       "9edc993f01d19eee8259d7d335a48f0a47fced3691471c34d06fac4ef879eb7c"
    sha256 cellar: :any,                 x86_64_linux:      "d651f0f18df87a5391b478d5805dd9bb61edb1da2c65bdb1c6d7d0b9545514d8"
  end

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  # downloads crates during install and binaries in the test
  deny_network_access! :postinstall

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

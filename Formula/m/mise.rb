class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.11.5.tar.gz"
  sha256 "3f90095c12ac22453bbfcc8fed8c4331a76c590252e30236ac4e7eb1553eee26"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "75153e507bf8b28401db756af84adb87765d00a0bd8889f90d5b6e57d789424d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4b1f195986da8e40968e5a75a8370606615baf1725b029a831fdabc004c316ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a0723b0c7eef1a75d4b814fa21de6b23ec79b212cd3e4f0f710bab5ece9de3da"
    sha256 cellar: :any,                 arm64_linux:       "7a61bce2cd82ce5001a9595f8b945ad6db5979ce6b250b64ec7619ac9c8caa0b"
    sha256 cellar: :any,                 x86_64_linux:      "2084014a05ff067d323b216f407bed88a4fc122f3c06cc3f303368ce895e5a39"
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

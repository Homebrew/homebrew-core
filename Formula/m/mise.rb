class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.11.2.tar.gz"
  sha256 "e7d6913cc7757c4e35357eaa1245ac4376ba7127dc438297f247c7e297c385da"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "60053b48bbe73c6fa3a852b1ad7d524aeb4520925c0487def29d4c6050d9f131"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b6504d7b268c97367d75bb6688387a9e83ba61faf0a0ac76bf4e50fc3504b82b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c4094937dde4a30756c9716e567508ecd13cb88c89fc25b13a42ff92b1966d56"
    sha256 cellar: :any,                 arm64_linux:       "e0f836b3a0c804fd742c6f24d69cc002ed18513f9dad7124337993558fa9e45f"
    sha256 cellar: :any,                 x86_64_linux:      "5e51362b2f0f394e2d57ce0bbb63805e67d0a6b6d22c744672c8318cc39770ad"
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

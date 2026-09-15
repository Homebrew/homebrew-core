class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.9.8.tar.gz"
  sha256 "22061e52ef8e8500aa8c944e30717ef3dbd0aba3ef1457f5c986a78644d56fb9"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a1f3ad768ff883434c2ec63bfcde19857f35fd5528fce1100646daa5cf6e1b44"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8ad5c7cdd7e85ba5c0640f498b870e8d49fa8b5e500926911884d20bb67788d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "695a2d5cc64a9489659f0ebf9a98bd0055d603a8841b393f53b74d8d6c43e49f"
    sha256 cellar: :any,                 arm64_linux:       "0a98f81fe18ce6a6e82ef3ee6620e04b457bc977f8be245714f99ef82592fc73"
    sha256 cellar: :any,                 x86_64_linux:      "1c35f7be286d88f6d874365f04a8c40f6850f391de8562931e12277f5a285c00"
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

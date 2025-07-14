class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.7.10.tar.gz"
  sha256 "bc86c543a313c5cef7a23c8887c751f7ec3e56eb5916523052ad71df3ba686ee"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0562027ad09376ae527c2f5751834a26cc10126718bb508e28a6fb31c27f632a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec57bde3d86de57a23a39d4ed253af94cc2e8701adcf7b08286ed8bec8cde55e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e06511496810b428cc6f7d5fa9ebbc4d53bbf3986a8ef3c107c4cdf26e91d4f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "f573efe332bf1cd883659fd9b26d1d611dcd7eddcb0ec92f9e909a2524d2ab36"
    sha256 cellar: :any_skip_relocation, ventura:       "68b8a9d272549016591112025933295e9f834f2cc593bf83dff45f97f4965305"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "459ce103831d6ce1dc6031d1e0fc30c1ed18f90278a0494b4ee644cc03f67a5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4f7882630135a5fcd1288400c30c0a98fa0130d9b52fea3be5424e395f929f0"
  end

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
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~FISH
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

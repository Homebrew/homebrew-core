class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.3.10.tar.gz"
  sha256 "282697e7194a32261bce4d4a653527f79bafbb2274a6557ca877e24ac4076691"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c0feca454ad7a84230b884941ee5c29ae0dbd15c224c3a9b33ffedafdd373c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2eff0225a53878a34a80ff717c6275295a0e3ed782aaf4df224ac949f5e7671c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef44d248f51a14922bf4f4f360828389f3e9eb323d39b75bb8677c5ebdaf7f36"
    sha256 cellar: :any_skip_relocation, sonoma:        "bd3daa2a84611e31157eb04dbd34633b7deeed0b80e207ec98a5bc6cecae5614"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbedcfd2b00d915ac9ea1e5f3e06a3cbdba4c792bc8e250814d0ec122f9a7179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3dbff829046a84a1f1ecf1b1ab2152d3d5a3c215be50adae972b9f19f8a0b461"
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

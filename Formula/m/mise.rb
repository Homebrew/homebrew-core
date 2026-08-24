class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.8.12.tar.gz"
  sha256 "caf5c183df74c5999f386a51432c8da0a132de858a2b422b7f2d02e03db5187f"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "557b78b25b1cff80c0fd14eb903b5feecffe2a9a0dad70f1a6c54ef6d3f2d0d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1282974b6de618e1f538511da3e526538b47ce224a0c5815910600e2f745af27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e41cc6ea7cdde4c6ab81f9fee029cf99971f6ff3c0391e32fff7dd2d8762847f"
    sha256 cellar: :any_skip_relocation, sonoma:        "18f4a0d9d86d887d38d5fe88bedbe8f4fef0da2b1456e5ba7bb4f0ac7189869f"
    sha256 cellar: :any,                 arm64_linux:   "9134b256f9e52f7b71f446fc821ab386ae4785ae2637bd401d2c2d9dbcd56ff4"
    sha256 cellar: :any,                 x86_64_linux:  "63af4989fabe1d48fa019acfcce3ea4a5bc1e21a202b52305bd29cc1168e716f"
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

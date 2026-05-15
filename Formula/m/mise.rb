class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.5.8.tar.gz"
  sha256 "6f90fc73db4f2aad9de30977c7d2398f2d734c0a3d6f96560363117522acb990"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a9111eef0a588aa6f24320fa20f3f0f6b4e46d47ec48bb790221509d3f51463"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0f8f9d51cb5bdbe536a52f50138c2289ce0f16dc2b0ebf9f26d5bb3b7054666"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c35a5ea01426d0df0054e83a8b8760e87370e85c69fc4320d9d39c52639f355b"
    sha256 cellar: :any_skip_relocation, sonoma:        "875068e008443cda9f1659d46bf71fc022e9bc0b05509901736de8a4ecc6bad5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c95313e467cb3bf4b76553ff75e19c9882c9ef142d7b6a2b903b9fbacfa22c4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10b38f561f8fc522630374c4c4328c96b5c445a4b2fe87bb4091341b6d41125c"
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

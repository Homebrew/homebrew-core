class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.11.0.tar.gz"
  sha256 "d0335b5280fbff573af12c8f1568c36fed037bb577abc8ad80139b8f6b554cc1"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6196966a0418cd936cdad7601b2fb71618ffca42b03ef2768d491b2463b2e174"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b5f4b4764a6db7f74ed6483a4ca3234f033cbcc9f140666e302e3322b943691d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "db64b9ecb039cffce1d79151f91d8d5e4483718970795212ad339f8d79255506"
    sha256 cellar: :any,                 arm64_linux:       "72f70759df9609cce500107f84dd4674ae3b78d3b8005923a49e7c74bf80cf65"
    sha256 cellar: :any,                 x86_64_linux:      "867e3f0cee41a8e68bb8243a659a11a472189304f9ee317bee947b31248a8471"
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

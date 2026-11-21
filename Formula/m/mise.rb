class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.11.12.tar.gz"
  sha256 "5b20b1175cb3b8396c08fa216abdeb2f3b447794be6750d99fd0badec0a24c75"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "de7aebc46a2c5f58c41561cee5e758b3a64275ecd6b5326b5da6589ea0081573"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a87c2a4c1a972e9213b24e143e457b66c6dd8f2f9c3930a22773418dd0578771"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "53f3f206aad5e44277801b9051ad3629720af0594448fca8a0b2cd8e50d0ba67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "86dba4d8b9370e374be1eeb0e9d54e3afa2f3afb9e1ba00a2f690010ddec9b61"
    sha256 cellar: :any,                 arm64_linux:       "f6cfe465a367b6034a0e3461241b23a350274fe26a6aaaefb50fcc76ba60624b"
    sha256 cellar: :any,                 x86_64_linux:      "e3c2b75536082ec859a2a98cced4bda158879e449e0e25a4c80f9f083b1fa640"
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

class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.11.13.tar.gz"
  sha256 "56e0897889c59edd79dfc7b3237e9b16b5cd09cc33ba22ce247e0dcc3e1eaa31"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "825034732ac9ffe13cd9ccd75461aee347dde603e2668bf6e207f8cf41dc7551"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c17c3e3e788b08e1fd62d5dd7aae0c5a72d5da8a7bb3c14a9821cfe301fccf52"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d335196d0ad591385a107be3b082b2cfdb5e7d944baa0f2a3b600128b76a3941"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d7714da4876f718448a01bb7e6dbe0fcbe079aa64d5c0dd9d350ecc6c92ea18f"
    sha256 cellar: :any,                 arm64_linux:       "4e1af39f9fb18e23c5245ec517735c5e32928f42b0e81cba42100f848f921a46"
    sha256 cellar: :any,                 x86_64_linux:      "c3fa12245b0f8bf16945b96d69ef98898c1f8ae0a05a3acdcc92394b1959ca54"
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
    ENV["OPENSSL_DIR"] = dep("openssl").opt_prefix if OS.linux?

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

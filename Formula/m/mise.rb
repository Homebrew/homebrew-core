class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.4.18.tar.gz"
  sha256 "195d91364319e0e09051350810ffe3f40f9354d92e801fa81bf52a3fd14d9f3c"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "647934b9c92a174311daacbf144ec5828ad5c69e9e0cb0afcdf5ad35690c5b3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7cb0bdfa5189f966c18d94101a7b3946852f8b4028ef65bd05515d29e632772"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "650ffe4856c7fd48c7e675d4900f81efd471fc4744ff8bcd691ba778faa5cf20"
    sha256 cellar: :any_skip_relocation, sonoma:        "c82f607e2f26315ef11557a6a14ac9244f986b6214f73ffc6bf0d7b2cbf5a11f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5aad522a7d69a0a50d87b7ecf9449fedd505cdb7191831ed7f3063347c608e9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4283f9a5f5b36fb5f15d474028f2ab7d428203b6274f2c0bb8d06b74b5a0c52e"
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

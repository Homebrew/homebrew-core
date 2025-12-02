class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.11.11.tar.gz"
  sha256 "ceea40a2d8b4cda5065ae122a53e37a1a9702bbb725ed5c3f8c948b0e103a10d"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb65ee463c528a4e3c9cab9f22d808b973ce5c2017ad2d51c1a951da0ab9a4fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cfa661be1103d9e85d7ab07c62ce1b36dc52cca95aee790e30e4317e35f8555"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f9fdca69298162acad1ec28bc723944e25f562df0fbb663707db30779d514a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b1b1d1bcc27b951bae31621632ccdbb31047969bf84779dfd765f42239f734b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a76ea5da57e2202f2d1fc9492527310a75cd9c49d116115b0b4b28e0c10e4b31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cec677c2e418ecc6ff75e0935d98bc111b8cbe9896dc8581becf38f13372bdeb"
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

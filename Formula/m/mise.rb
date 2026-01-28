class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2026.1.9.tar.gz"
  sha256 "2900923eaffd95e9a20fac03001ee1990760923d177ff8db0a04bc6113c46e81"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b3c309ed2ba4b8b3b022f80a0898a59dd5386d5d666d1e0b31068656d40a78b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a54a1c5cd9612736eb1e3ecdcbd52579971588883186ade5f98c2699dbbbecac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8bb6a4e9a15013d69cd89518f6f22feae26578a528c53605a85b246e6c281c13"
    sha256 cellar: :any_skip_relocation, sonoma:        "519fc48dc0adf5558ac8b467636d40a487c03ae2480cafb9199d924674d31f62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed51fdc8f75605500f8125ba63073d090a95d1cec4cf777027fedff67ed959e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85743412439f381b69da9cbfd330c57bb17dab6413bdff8f0cfa0129c938eafc"
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

class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.5.10.tar.gz"
  sha256 "ac64cd4eccedd9ee46f3982ad40493b5e72a89a00dae61104ddae62faf29425b"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59f718271b91924d66d1f2914735ea0fe5423cb5101b0914e654464910f540da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4c07a9941d080b94b1d93b6b78d7229946067e16d9bfa08ea1fec306320af04"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a9a0ec9717db203b93f4a8c8e57e1e2059e1e830b699dc10c77843268751dd8"
    sha256 cellar: :any_skip_relocation, sonoma:        "a89ae80805e806e80993b1a92f9a305285d337f880b00a3600320a2fdc698640"
    sha256 cellar: :any_skip_relocation, ventura:       "37207f0cb1c77d2cbc9290240b3321902dda28d7312b80b3e861687418c37bc9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5a09b9f1af4392c07f39c2b934e3f7b5c6b4b662dd3f461b9d405ff5b12654d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8ebe665c17efdccaf17e6b9a6add176aa9ed38ca2615f4d1c52041f3b484de3"
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
    generate_completions_from_executable(bin/"mise", "completion")
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/mise activate fish | source
      end
    FISH
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

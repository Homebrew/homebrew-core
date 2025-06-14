class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://github.com/jdx/mise/archive/refs/tags/v2025.6.4.tar.gz"
  sha256 "ea8e4681dfa52a7c514f88d35a28e5456ecdc317232fc890360d6d68abd8dff0"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f24cac260da6e5bf0996b2499d5d1985c35745dea58e101faf561b61b869896"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cf0b2c6ab236d6e5a395c74d36e33fa320310eb438a8e1628553deb6d49508d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7df83c9060b4c1ae0f03492c8ecf1e86a1bed4d21b841a0a56162f0313514471"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb16bc2cd53234fdd0b514d8084473f0a4f51e4ece1c4fc748bcbb979d7f81f7"
    sha256 cellar: :any_skip_relocation, ventura:       "92d0ddfccac63e79623da12c592fa7a2dd4608c442f5dc7a915e773dff713ad3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99f94f8258fc7d6fe5bac8a370e5367775e7907aea4820c8c617e7a81ae87efc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b90c0e90c4ebe8fb2c257fbd3840c16ed1e02dd680dd31d590390dac977933d"
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
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~FISH
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

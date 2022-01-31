class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.17.1/pandoc-2.17.1.tar.gz"
  sha256 "876a6d454ee8b00094ab34100600e55dae006cf46f1d1b6ef1ff5702010b410b"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1684c58e3a7759d2aaebb642d6f87602fe22396795b355b2ebe26c27df6b9fcf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d94819b82451039797ff7e414b176a9da4186d84a4ed646acf968fa940cb26a"
    sha256 cellar: :any_skip_relocation, monterey:       "c994de2a47d996e6d092cb4d39e0f06a11163d3e68dea0c554ca51dcc7232a21"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e051cf7a85d7eca4b6b6646021829fe5d6e8dc74836c55bdfe20e2563225e2a"
    sha256 cellar: :any_skip_relocation, catalina:       "d803b7f5ce1ada623394b01f37f9878e679c5365096b849355a0e3e6b30e3f08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e7bdf283913529846ae892bb477be6bf945005a066780579ea9e529f411aba3"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "unzip" => :build # for cabal install
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
    (bash_completion/"pandoc").write `#{bin}/pandoc --bash-completion`
    man1.install "man/pandoc.1"
  end

  test do
    input_markdown = <<~EOS
      # Homebrew

      A package manager for humans. Cats should take a look at Tigerbrew.
    EOS
    expected_html = <<~EOS
      <h1 id="homebrew">Homebrew</h1>
      <p>A package manager for humans. Cats should take a look at
      Tigerbrew.</p>
    EOS
    assert_equal expected_html, pipe_output("#{bin}/pandoc -f markdown -t html5", input_markdown)
  end
end

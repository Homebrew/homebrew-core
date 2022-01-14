class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.17/pandoc-2.17.tar.gz"
  sha256 "c60f436a46ae3b5e6c28598301f6970ace10b6a4723de5be4dd47fb97f257871"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65b87339c01f5311f37c91d67f620abc7c3684b40498aa6e19036f911f68969a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "670abca89612e7e0905a9a93ea9adffcc5756f62c147c5eaf7a73454738bcd54"
    sha256 cellar: :any_skip_relocation, monterey:       "139b66f7708b91a435fd1b3329cd1259a0543130a70da481db07bdfcdec61b8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5cf1538dd40056f3ac27d87b08021095be3e05b6bedc51a83f73bfc349a853f6"
    sha256 cellar: :any_skip_relocation, catalina:       "ac8c43af1661e7304c44bd9443c5485152fdbd284babfbc7eaef1247816ced48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e5354e16aa00389fd0aace7eef9ef235ce2f9af74e2e35b8a413e277aa09b6e"
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

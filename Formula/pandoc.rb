class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.11.1.1/pandoc-2.11.1.1.tar.gz"
  sha256 "6864116101e725967d19b5328f9e73abf2b82ec379dc61ad8a0b63e7349d2644"
  license "GPL-2.0"
  head "https://github.com/jgm/pandoc.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e1a68f906c85f2c283f4b1405ffc148ed88ac5d8e3650c7f2d3cc8c001306303" => :catalina
    sha256 "e0176263a3b167bfc2585cf454ea0e9daff9928787073ca2ca9b9ee9bac14ab7" => :mojave
    sha256 "6adf2a474dc906d0b3ec0ace28a9a20ab652d4da04bce291cc18139856659643" => :high_sierra
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
      <p>A package manager for humans. Cats should take a look at Tigerbrew.</p>
    EOS
    assert_equal expected_html, pipe_output("#{bin}/pandoc -f markdown -t html5", input_markdown)
  end
end

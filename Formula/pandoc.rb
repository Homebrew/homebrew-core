class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.11.4/pandoc-2.11.4.tar.gz"
  sha256 "d3cfc700a2d5d90133f83ae9d286edbe1144bc6a7748d8d90e4846d6e2331af5"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "2bdbf3d2f77426ffc5c3af071c2063db4082475837f479499412ef187a4dfb1a" => :big_sur
    sha256 "29e30b1de3a6462a669b2a78043d3f240a4d5d3c6f8cac07997a2f7d2f77991f" => :catalina
    sha256 "7cdbea784987ad599c69fa8f83f0d6b093957bba848eb3d52e859ab977345fa6" => :mojave
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

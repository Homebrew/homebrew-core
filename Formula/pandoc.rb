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
    sha256 "a28331398b1a4f5d9bb7d69ad26873a631ac1e7fd21340557203c753d2cb9ebd" => :big_sur
    sha256 "659efbfcc719ee51465ac4f5045eb2f4b8aff89e4eebdeb07663b4cbd2deeecf" => :catalina
    sha256 "fc024d2d3d8aba91bd4e7c5f0650e09080086c380fadee566ec7c3889b5909c3" => :mojave
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

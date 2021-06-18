class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.14.0.2/pandoc-2.14.0.2.tar.gz"
  sha256 "2e29aed9253a82099efea464fef54754ca064691aec9b97e78f41a9a449fccca"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "975b9f451445732c2e930e034181c07507ab71ae8305a736bf727a284bd37e71"
    sha256 cellar: :any_skip_relocation, big_sur:       "3d4002ddb6ddd3f2d6aca29c946ffaf207cc6bccac03946a3b2aede6d6507881"
    sha256 cellar: :any_skip_relocation, catalina:      "cb2281047b520411276f20bd6ce637ce65c244e9d8eb7003a1df9a881539610e"
    sha256 cellar: :any_skip_relocation, mojave:        "d17c6091733ec917025d90196217420ad8fcb613bc80d9a5c781998b7878258b"
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

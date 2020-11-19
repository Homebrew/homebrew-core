class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.11.2/pandoc-2.11.2.tar.gz"
  sha256 "cb0af254176870ca72f89170ae42fa9cf97b8c5ef4ea9bffca7f3d2e5bdde282"
  license "GPL-2.0"
  head "https://github.com/jgm/pandoc.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "10f88e0f6d822432a7500de9b256b2a3304901256a0abbdeee4e4091218fc5c7" => :big_sur
    sha256 "7cdcf09a97ea9156a2450f67f597099b31f6e9826d4e3cbcd1312871f05964f9" => :catalina
    sha256 "5365310e20e9caa6f14f2c884c9a05348568d96398cd05b5c497ca65e2106a53" => :mojave
    sha256 "383bbdec7227f3c0a07b193d2ff00915c654e8d3bce59528f2450ec6a4d18d60" => :high_sierra
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

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
    sha256 "c0c2dfcfb22df26903844595a9d3983222b3b977d958b24b31b513c5a21acccb" => :big_sur
    sha256 "1f3e1a1274efd7f89c1a6881b9ccb14c19cda7bd4c2b2d31ab2ea9169a806643" => :catalina
    sha256 "ad8a0e23ceafd4e661699dfb47ac42bc63d2c019f6bbb3e9214b84def01671c3" => :mojave
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

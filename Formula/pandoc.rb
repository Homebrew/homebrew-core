class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.11.3/pandoc-2.11.3.tar.gz"
  sha256 "b8a3f4acece543db8a59a41bd77ca53967d3e2a6e05bf5aaab76d25098f5cba0"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f0d15958e8bd2e9e88ff435ca71b4c705e06e76382e325c79d8340e692175e46" => :big_sur
    sha256 "71f84107d5fa6b57abae08ec5e0909b3eb718e31b7972753b3511e0aab1e289e" => :catalina
    sha256 "5730d5880df06f6784df25d8691f25036b53313954bebf011cb2b27dd374366a" => :mojave
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

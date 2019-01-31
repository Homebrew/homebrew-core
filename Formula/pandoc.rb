require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.6/pandoc-2.6.tar.gz"
  sha256 "aa761fe96161d042e01d0881fa569ec396da02ebce42562e04fbd91d8ff2db10"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "daec3da0ebbeb6674a6efc2cc8a95c5563fd393ffa102fa1d8b589b5c7026d3f" => :mojave
    sha256 "d8a8ad1220ff8aa672e3c6fe88abdd22b27fd69f5894e8f7821e70f0c7650154" => :high_sierra
    sha256 "cd93731b019ed9a377761fc277ecce40a9778306d24a0addafa4c22ab42e5319" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    cabal_sandbox do
      install_cabal_package
    end
    (bash_completion/"pandoc").write `#{bin}/pandoc --bash-completion`
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

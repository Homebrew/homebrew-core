require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.7.1/pandoc-2.7.1.tar.gz"
  sha256 "5e2a51f130e0fb39f615f7b9705f8e152156e30de4a71e1c900d1ae2ec8d1eb8"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "09a6770c5334f02e944de90f28f896ca69f4f3b14b16511d4e0ad2804c9d92db" => :mojave
    sha256 "4ec0d9409dcd1d6c290f2622187d91dd10442d83d9af3087ba9f966e13e918b5" => :high_sierra
    sha256 "fee5331725b9cd2195280c6491e8b94d49894654e6fc7771f1b6559163bf376a" => :sierra
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

require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hashcat.net/files/hashcat-5.0.0.tar.gz"
  sha256 "7092d98cf0d8b29bd6efe2cf94802442dd8d7283982e9439eafbdef62b0db08f"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "38fd890fbd31e4013ddfabea84ca8d70680b8121e675b9a74c241a66da1ce27d" => :mojave
    sha256 "6c34f6b21e8c280df488f4916b621de0207d84471817ca2e6581ac8a8a514ee2" => :high_sierra
    sha256 "a6dcfa11f697e819a272ca8e6454ed1dd7909e4e2a6c86b1780d2c46aebc5192" => :sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    cabal_sandbox do
      args = []
      args << "--constraint=cryptonite -support_aesni" if MacOS.version <= :lion
      install_cabal_package *args
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

class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.14/pandoc-2.14.tar.gz"
  sha256 "88eda1e01828da310429b3cbfbdb5ff80ccfbc0d7158f88c41e9c409ebb3f9c2"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "05bed41434d9678edf93ec4d7ffa905f248eb33c2c4cf8cedf89808be252c904"
    sha256 cellar: :any_skip_relocation, catalina: "b56dfd209f84ae6e7b937f45d819b6065b6bae41e21c2b983b681f695f9379a7"
    sha256 cellar: :any_skip_relocation, mojave:   "877e64b3618740f71f3685b10df8f63eb5616110b6632d1d405aa308a140aaf3"
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

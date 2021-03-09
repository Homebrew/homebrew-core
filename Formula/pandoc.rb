class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.12/pandoc-2.12.tar.gz"
  sha256 "5517f22b3c026d19d5904f9cccdaaa2aeb49239fb49d6757524047e93034f27c"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "2923027fba56cb74eca262aa67d6ae39000a866e6f5229d586a065e6cf28accc"
    sha256 cellar: :any_skip_relocation, catalina: "c43ade7a24c3ed9b39479382d09fdf648555491c68829d669b9f33be200c3387"
    sha256 cellar: :any_skip_relocation, mojave:   "c864d23ae7b1d12d3dce37228aefc97b63614850ee7a30e649733dc0a614ad83"
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

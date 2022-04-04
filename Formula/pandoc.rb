class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.18/pandoc-2.18.tar.gz"
  sha256 "d4d354781d76edc56039d11aa5d83a434fe793158823a9ce2e0b9897886ae609"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "318fbfce3634193ea4242c73b8d7e4a3e6322b4319df2ac376fa3faa820c91c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4d418739b29403698bc541d78ad0645a515373b60187bd5afeb1179ecaae6a4"
    sha256 cellar: :any_skip_relocation, monterey:       "d5a3f5bb295acca845f5de240a17733aec4dfd1cd81c4533f9da65137a577b28"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e6fc53816b145927063c27915df029d0c7be3747c39501dfe26e1af72354f4c"
    sha256 cellar: :any_skip_relocation, catalina:       "0ade4c9939b5d8f130c7d3c32f5d9dc767fd8dd868f40114c401fc6effa6f34e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d2dbcffa36a46a301055221f05ad32f7c525352184291c138efacf955af93ac"
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
      <p>A package manager for humans. Cats should take a look at
      Tigerbrew.</p>
    EOS
    assert_equal expected_html, pipe_output("#{bin}/pandoc -f markdown -t html5", input_markdown)
  end
end

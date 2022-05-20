class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.18/pandoc-2.18.tar.gz"
  sha256 "d4d354781d76edc56039d11aa5d83a434fe793158823a9ce2e0b9897886ae609"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9411a015436638767a62eefe22891228dfc00ee5ab3d1469637f65a83bf07f3b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77318c0209980baad255423e1eefbef40d696be949770be3d189554bffab3d64"
    sha256 cellar: :any_skip_relocation, monterey:       "2c975ede0463a4135548342e436d073a724c3643186a1daa6417855261f5407b"
    sha256 cellar: :any_skip_relocation, big_sur:        "87fcbed2bd56b65fd815197048e4926abeed631e35dc4770b9b3a1e3049eb285"
    sha256 cellar: :any_skip_relocation, catalina:       "79354a16ef3a9ab20d9911f97cce261a039ad5109bd2f134c96e0febdf5414be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5925683a5d57816ea6da9eed054063fa3cba5863282c912162622d56e1c53d6"
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

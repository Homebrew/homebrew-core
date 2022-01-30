class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.17.1/pandoc-2.17.1.tar.gz"
  sha256 "876a6d454ee8b00094ab34100600e55dae006cf46f1d1b6ef1ff5702010b410b"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2440d38332c41dfe4855c6fe4116aac4e7bb3e65b9bebdff9ec52e6699869e3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ab6490ff8c1ac3653cfb9f94c29fb86459064a7205ca7ea48dbf9062cfe3f86d"
    sha256 cellar: :any_skip_relocation, monterey:       "7583795e55fccd6bd62060a388f6a157290b7e0f882a4e92fa4b6648d779960c"
    sha256 cellar: :any_skip_relocation, big_sur:        "23574c76bddca7a0d6fb69026264965cfe682e7ccbb8bc73aa3e4e128d379971"
    sha256 cellar: :any_skip_relocation, catalina:       "925542afc6f1385a2a99c9a58f9298c18aac040ebd729dd9b7cb0a907b0d6557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76b135d40890fe5ee4acd1d2c11e599caa1f5ec45aafa4d9248be2120f5be65a"
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

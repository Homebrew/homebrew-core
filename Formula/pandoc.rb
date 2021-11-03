class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.16.1/pandoc-2.16.1.tar.gz"
  sha256 "eabb76af3fd72e3289ebd34fae183b9841d89cf6486a0c7d050272bb8ccf55be"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a3418fb189635925e59426e9b09221e1dc2ba3b530723b384bfb2941214ff56"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9c37b895ef5f8a88f6eb8b810323ca2c278ac15f36a9167314f79d5d66d6e26"
    sha256 cellar: :any_skip_relocation, monterey:       "ad0d922fbe671a69bd94b35a088258c6b649ca4568e44b6d24469a3c2943e3fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "179216df578900a008b5091f63e55fbe5fbca551dbd774dc9e879ae6d9446ae5"
    sha256 cellar: :any_skip_relocation, catalina:       "5f3472dc313a4439de298dc6d1f521678e928606103c800b4b4ddb5c06afc6a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fe8ad3d8830eda73a8cb40ae392e1c09a63c21f2c30eb35e7b08a484b43b64a"
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

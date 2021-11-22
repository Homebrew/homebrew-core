class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.16.2/pandoc-2.16.2.tar.gz"
  sha256 "72f291c5b9642309ff1010eed2c990d0893923e52982f7864c710111cb26dc5e"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eab3e24f6d4ae14759d62d422ab3afc54a161305bfc627a27b10de66ae97c193"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de771fb477b69d06151b93617f959c0b279f897ac53f94ab4ed8d701704fd91a"
    sha256 cellar: :any_skip_relocation, monterey:       "59c63f2b058b639d6fa10b643504c95c37d611b60da3f79190b933193be87d6c"
    sha256 cellar: :any_skip_relocation, big_sur:        "beac0626990ec36951b3d9dbe9c9d6d39fe7668ca9c85de387a6a0af74a32dac"
    sha256 cellar: :any_skip_relocation, catalina:       "dc75dfbbc080a9567b15a5dc2277fd4344e9cb8d0806ffb01623416325189040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "314521912e64cdb6764e92f0d15874f986147a9dffa7dfe4b0e039dd254254ed"
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

class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://github.com/jgm/pandoc/archive/refs/tags/3.1.4.tar.gz"
  sha256 "ff6a72b125e78b038e2e410028981301a000162f7e7693888b7c131e0f3ee6e8"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e193c19e5d45ed2613197e1e0c72e8137294fa931206a56ef412dd5202b906bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5586e769f7058dfebcdc934b1bf48cb89fede65b69f98c7bbd73791bc9daffe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b56ae2d4e664fd98199a1ce9e49737a7efd83f1803d3c9d7a02725852b8da6c4"
    sha256 cellar: :any_skip_relocation, ventura:        "387f340e3a2e678aac52fecaa1c826fe70bbbb7536437ad2d2e39acc603a2b3e"
    sha256 cellar: :any_skip_relocation, monterey:       "d2f3f0d5ac9e5bdf0ab2e5731de2bd089cff9851557df10d2498db8206e18894"
    sha256 cellar: :any_skip_relocation, big_sur:        "04976357da502b41fcadaef2900d328134df01770328a5ef229ca7a8b16b8866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "136dd62558e616f01bd7c578c917b1dcb21824d7e782ae14154032e74346b1d7"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "unzip" => :build # for cabal install
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args, "pandoc-cli"
    generate_completions_from_executable(bin/"pandoc", "--bash-completion",
                                         shells: [:bash], shell_parameter_format: :none)
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

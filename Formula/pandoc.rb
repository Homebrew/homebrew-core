class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.19.2/pandoc-2.19.2.tar.gz"
  sha256 ""
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "446141960ac626b10762f6b6534c4ba8467eb851ccb40f1e69bc900b16b7ce3b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d03001f8a238a2eb21523a8ec33b305aaa26b30cf68aaf5f7c5a99ccad7c4c8c"
    sha256 cellar: :any_skip_relocation, monterey:       "de7dd6cfd6e5a21d169ea3a78a7f87fe4f0f8f1c611497c9693c7603d18818dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "72388faa56c673946a087fc488e170426e51528b3688636979d8532554bbd665"
    sha256 cellar: :any_skip_relocation, catalina:       "e876f14ff71a12c826bee2e0261a5dd44016a3a4a2a9c92f7cbd8ac2f2152ef6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a18ccee7c9315691d44f749b252e5614071541769e1a7d473e68626062fcffd5"
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

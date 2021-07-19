class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.14.1/pandoc-2.14.1.tar.gz"
  sha256 "d8634336ef05a148d380ebd655b605e60a51415abc0d178068f717f2550840ca"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4a7a334498f6172dfb54a8ce60691b17dde78fc0258454f593ec17ed3756740b"
    sha256 cellar: :any_skip_relocation, big_sur:       "5afb1727f48a7d1e0053010a6353ee2c60914f472e48755c9fbd187d42ccea68"
    sha256 cellar: :any_skip_relocation, catalina:      "2fc54c62cb423d439f7f75425e34c9aca11c401076429d5f4562c536e633b9c6"
    sha256 cellar: :any_skip_relocation, mojave:        "c5d71fd465032d0c6bf3937b6c58d052d59e39827152ac9fd9081704c805fe49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2130acd7eb264f313e036427322abc05b1de55a216dcb1587ad8d929e4507d76"
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

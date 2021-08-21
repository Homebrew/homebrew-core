class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.14.2/pandoc-2.14.2.tar.gz"
  sha256 "2cf7d376125671c8d0d0a8b1216cf466dbe050cc150b395fb7d7f156622b5cae"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "de69a86956681d5a69fb797e9223c93606e44d9523b5d800f481d39c1009e3d7"
    sha256 cellar: :any_skip_relocation, big_sur:       "27e30c0b56e5005f792e13e1f2c3a92f7ed7b30b04a1f21a8dc7306dcc81d0f9"
    sha256 cellar: :any_skip_relocation, catalina:      "08c9812e82e075c44dbc691f4cdfdafd5265500bdc03c47835c9be4e5fd46950"
    sha256 cellar: :any_skip_relocation, mojave:        "790cad386bfbfaa3c972c04b4ea0bfcb6a7de3e01f8f41211e9e940ff5a143e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1012dab5b576721344348054140c3f560c6c5ed1e1bfa3891224c5dd4b6e764c"
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

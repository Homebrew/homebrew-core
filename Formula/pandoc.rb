class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://github.com/jgm/pandoc/archive/refs/tags/3.1.1.tar.gz"
  sha256 "e3203bcf48fb0a91c7e9405c0e5220b251a5c2dce0b4973eeb00f16964610e8a"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd62329bbe97d55546914941b4c5b4433a80357c0c3d5726151d9e4f71d9372e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "221ccac4abba1e1e9207883e6cff8f6f7ef4909314772fa87cddcff583042f95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3eb91cb849009dbe3740b3bae8e5c8e49ce3961910597e8aeb0646456420bfcb"
    sha256 cellar: :any_skip_relocation, ventura:        "4bdb9b4c16797e18cbd9221be296a2020632b296ddd69be85451d4fdb82d6ab4"
    sha256 cellar: :any_skip_relocation, monterey:       "fff25a6f5ada0fd9b18859730b23cb3edfefc01cdc9a6483c726771932084f5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc8f95b22cf5af18be1f6fe47585774e0dbe7739584e0917fbbab03ee47f7d1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc2b09035163a5c751df4c1b5b919eb773a44b57625a2c0c90de6124a212acbc"
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

class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://github.com/jgm/pandoc/archive/refs/tags/3.1.12.3.tar.gz"
  sha256 "999b119171b92a5f6697d2dec89df49b629506d0f34976a94fdf35e9ae4c5d0d"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb35ed843ab81fce4d1dd218169d783693cc7bc468d5193eae318003c8002fc5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c64b6d92a38427dcdb1c93ebfe6f38e75bda8a5961868483d17d0732e8294581"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7cc7d38acfa9d67c09f8da4e13f8817c5e50370b81e96a8a5dd1f4dd3f53418"
    sha256 cellar: :any_skip_relocation, sonoma:         "317aedb07d32253389cfa747cc38510ec0e7c6d91568aa1d8ac4affe90675066"
    sha256 cellar: :any_skip_relocation, ventura:        "f39956a169e149ebbae08e2339eb53cd934a4f2c20ff34af46c6b9d5b4135e45"
    sha256 cellar: :any_skip_relocation, monterey:       "d4f0c43fb24ca9e9c9ed5accfbd9d56356158d351483f49dc6bccbb1cfe2d737"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb6053450fd7817d60d0489a116eb53751ec1c920b8261dae3cf51f78b44b27f"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build

  uses_from_macos "unzip" => :build # for cabal install
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args, "pandoc-cli"
    generate_completions_from_executable(bin/"pandoc", "--bash-completion",
                                         shells: [:bash], shell_parameter_format: :none)
    man1.install "pandoc-cli/man/pandoc.1"
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

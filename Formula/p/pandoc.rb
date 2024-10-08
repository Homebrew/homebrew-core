class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://github.com/jgm/pandoc/archive/refs/tags/3.5.tar.gz"
  sha256 "1d378e5721eb26ebcdc31232dcd26d041eb3237e85ac3650ce809e9fa0fcacb8"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0e1effa23e96fd7aeabade0da2ba30aba26022d23c4a300e4d89250a733b6ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "423a1a43968e90be9ffd7ee744846d437a703a606e45673f4f7fda32ad289563"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a3358e15498855a569cc0373961d70745b0af8b870034a93a99aa73214021dd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca547d7cab7d8193a3be16f443a479ccc3aa3220698aa6d39f368032af881327"
    sha256 cellar: :any_skip_relocation, ventura:       "d77b25257036107ad9da955bfe13c9d52d1d7c4b625fbc82b4657e25d02342c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6409b83fd2ecd212973a01798722ad95bfe2d23fb5e4d44ee509f1326ecb5578"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.8" => :build

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

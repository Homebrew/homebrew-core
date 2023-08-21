class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://github.com/jgm/pandoc/archive/refs/tags/3.1.6.1.tar.gz"
  sha256 "879114698ba74374313a73303341139131b5f778833a508399086439141ebc88"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af772e197c5039c1a100ef1d100980066410592397d5df52f89338cade564e2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19175e1e7c569cc584def451910e3ebed7950ab69505e83e884eab1f1815c949"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "78e3033190a32c246a167fd2e64c381eb204b1a9de7d8d076e63e5fcd16b014b"
    sha256 cellar: :any_skip_relocation, ventura:        "48990ed983f2fd8eb3ae920223db561a315a38d46c8f0f7547f707f118a610ca"
    sha256 cellar: :any_skip_relocation, monterey:       "dbf6d4b0f7bdfc5a2ec8b7c9ab790b3cd8e498aedcec37607fbea2a8ef69d340"
    sha256 cellar: :any_skip_relocation, big_sur:        "bdac49eeef19ed1e9458a2d2807e9bd1ac10a104d2781e109dc5917a7730b5b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2849915e3b1a3dec330293e43663d273c3ac36b0ff797e0c878c8331f0767c3a"
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

class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://github.com/jgm/pandoc/archive/refs/tags/3.6.4.tar.gz"
  sha256 "a343ac43502b699467051948f24f53746d25391c25e3a8dadb30bbd7db313d81"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f0301201b216abcc0ba4bf6bc39ee6b94a77cdc9f7285a45576e57fe2699d16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dd1b5885da18faaf4b6ab062679578ad65ffab0bd4d62b24d3e913f37c5457a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d4840372e692b8dd8a29f5f209b78ae2d73886a2c9bfc263c157c3721841ae3"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3bc92d621607b1bea6ebda5374d24bb1ebede20d8039e73894b1b82051b9b87"
    sha256 cellar: :any_skip_relocation, ventura:       "0155aee5bcc2916df8a1a69232c0f43d1f9efd33f66cf96716cbb04558c446cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "963549fdbd70cdb14d55bec244eabd87f1c6735cba7704f8789ef559520fdfed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e4c600cc033ebad74e6acecef8358e8b7d42006651c58f79e07fb9f36860fc3"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.10" => :build

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
    input_markdown = <<~MARKDOWN
      # Homebrew

      A package manager for humans. Cats should take a look at Tigerbrew.
    MARKDOWN
    expected_html = <<~HTML
      <h1 id="homebrew">Homebrew</h1>
      <p>A package manager for humans. Cats should take a look at
      Tigerbrew.</p>
    HTML
    assert_equal expected_html, pipe_output("#{bin}/pandoc -f markdown -t html5", input_markdown, 0)
  end
end

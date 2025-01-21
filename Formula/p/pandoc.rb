class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://github.com/jgm/pandoc/archive/refs/tags/3.6.2.tar.gz"
  sha256 "068a0fd99dcd34e99aec0cd039d8d7cdb6b16bf20e338549cc562717c8bcb21f"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a69ed0a7cbd710771e76b783cf18b2645fa6f44b843d03b94c9436220b245ac4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e6e717d28ea8bb1d4b667ba3daf705bb1eb846350dd882c18e0f8306f1cec47"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e9f292efa0d6330cd188ae552124e78504ce67e545ddf26f54d6a3b3a99d24d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b76630f198e24fe2cc38742b479d70a8dce5bdf0831abd96c85b61156d7a25eb"
    sha256 cellar: :any_skip_relocation, ventura:       "337aa31dabb8bf7c8b61ab51452e023388f113bd23314091f5d9c51b9c0cc5ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "658b51bd383ad3331964efcc3eb3040191ccbb99dc6ad60f1d2df141a96d7440"
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

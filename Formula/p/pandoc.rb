class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://github.com/jgm/pandoc/archive/refs/tags/3.7.0.2.tar.gz"
  sha256 "a098c1dc8051844e3992f8396c6c947dccbc57b6ca3df2f2c47b9f7fa9f11246"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1a49a901b2ced92b8a50547723d4f7452772b8a1b2da9bce66639e129afda0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b60bd93b5547842d7d0a0c7cd370190d886f8668202d193d41fbd647c7e231b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "574b5c9ff56741b0618351e730cf57c77769df09c2773f4e078edcf040b59119"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ed6bbed48caac1f712c44ffd320688294573ee0a9c0b37bb69c7f7a2d5799c5"
    sha256 cellar: :any_skip_relocation, ventura:       "ae245cd313803946f6944125ad75eb46436b4165ad287ef35efbcec5e5e22c33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a67e9016e774478bb11e236cfb3e471598bbe327c184749767408b9e5ea31ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95c14392f3a2a9ed82b48f2fed4f34044899148c8bd35e04dd684b700ecff99f"
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

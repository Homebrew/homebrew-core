class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://github.com/jgm/pandoc/archive/refs/tags/3.8.tar.gz"
  sha256 "2d375526e7d26d46ebcdaf107564c8bbfd68e40a7af425906e9612889699bcf6"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "80e4784ed8e01ca7ea4ecc98a04dd14ca77de02a7ca1481eb213144d205aee5a"
    sha256 cellar: :any,                 arm64_sequoia: "3ee41fbc2c37ca43f9a1d5e9005328ad0848e4902fe170a42d8c930a8aa1872d"
    sha256 cellar: :any,                 arm64_sonoma:  "a0f027f9ae21d782a42cb6aed4bd1c093401753d638c5ef0e9b81865e3053ef1"
    sha256 cellar: :any,                 sonoma:        "dd6cec95b0a4843bada2bb028f1d70780f6df6a2a1a1088ebd87995f2a390545"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "151e60036a14ddfb9a34febf3dc783d341c99a4d8f400854f9226828599001ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f6994527b91f6cc6365839c0d8125b5fa1e2d223b45e4f9e56de15b8fe5cb9f"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "unzip" => :build # for cabal install
  uses_from_macos "libffi"
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

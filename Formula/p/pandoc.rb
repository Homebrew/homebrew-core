class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://github.com/jgm/pandoc/archive/refs/tags/3.8.2.1.tar.gz"
  sha256 "e3948e106026edbcef4e4d63f92554c814c779fa14696e635fb98e1279d4c175"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "243bf261875489e301064243e5ff66b7ee2314b46ad6713140d28fa775642064"
    sha256 cellar: :any,                 arm64_sequoia: "24eeaee65d0243cb8e2cc8af6b817cdfedf8e66dd62355a7e92d2222dee0bda5"
    sha256 cellar: :any,                 arm64_sonoma:  "6482bedf0add4caac5261ed1b398f9a7070bd16ff554a83f7b7ff6c27e6b14e2"
    sha256 cellar: :any,                 sonoma:        "3ef2c73fbabea2395ed9fd51c986774486e669fb611d520515b004e5c0c7ae3d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "402524fe0a947a6023b3088cd41c04f7265844d21d8e0caaef245da2189375ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ee2f465219c7d84eb055b7a582b7d0da88d9ce5869987e0c44a5f3c1457bbf3"
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

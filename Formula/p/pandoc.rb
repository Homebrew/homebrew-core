class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://github.com/jgm/pandoc/archive/refs/tags/3.8.1.tar.gz"
  sha256 "1d66d35952e7037cc049a9f170c9ba394693014a71925a84c55dffcaf98ff677"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "de1335f30bad4df53c26fc8f7d12f09412b22d3186c1d9c57e800281e75ed254"
    sha256 cellar: :any,                 arm64_sequoia: "8c5f6ed574073d2ef6821620d93d5f56225bb0a9e098f7d245743b1be0b1ce00"
    sha256 cellar: :any,                 arm64_sonoma:  "b48ea533c62b9be6987e9489e6408e21cc05221f77dba86030c94d54e976af6a"
    sha256 cellar: :any,                 sonoma:        "b2b424b7ad249299d1c02e47ce09ed830d2431c7a5da47d13c7d3e2d8f9a2b0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e51c6e70d648272fa01f375583a6ff69af679926e9dda0737dbd800857f7c025"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edbf643e6ea2cfcc3aae30012e34a4b7e29e13a94b72f0d15e1abda749280975"
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

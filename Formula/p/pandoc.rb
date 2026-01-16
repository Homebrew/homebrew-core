class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://github.com/jgm/pandoc/archive/refs/tags/3.8.3.tar.gz"
  sha256 "064775f55802fea443c53b9ad61b6af5aab3fcda71c40e8ccb97f650dce78640"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c701324c788c3d37d77fa3beba285aff7e91e9f931406082744f86fecf63aa6f"
    sha256 cellar: :any,                 arm64_sequoia: "f3875a6c57702c9a02abc2f45f6e4313d650704bbf89bea80044746c7cdb0e31"
    sha256 cellar: :any,                 arm64_sonoma:  "013ae292c9be6c9a592e8f585f429f88efd671cbc502281e68724b9069e3bf29"
    sha256 cellar: :any,                 sonoma:        "56e28903135c09615455ad5b500b524d9d84f7a3ee90732a870e0f3f0c4be7b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9948957559ef8779b7e845b84f59f72a29d7da8fcfbde9578aeda8cd9598c25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c96acda21739e17f8016312bc3d65e4e58793c0cbf164eb01e2e5a1c459cfd2"
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

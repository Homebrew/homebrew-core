class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://github.com/jgm/pandoc/archive/refs/tags/3.9.0.2.tar.gz"
  sha256 "c300c60ae4d47da6e5d265e93f89b896324cdc84ccbb504b88a9855bacd6b5d7"
  license "GPL-2.0-or-later"
  compatibility_version 3
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "40762c24f0337d9dc07466e365c0c3e0cb6023122bca9a6b36dcc0dd962f0b04"
    sha256 cellar: :any,                 arm64_sequoia: "94e1a3309022f75f42f7aba3c9d17f14fa743ad6704c469090e555f30c1c2552"
    sha256 cellar: :any,                 arm64_sonoma:  "400988089c12d7a44b9aa4f06214362ef3afd861a9fb2ef880787f287a91b989"
    sha256 cellar: :any,                 sonoma:        "61e744c37e05f28910e506d594e4304ded58c5785a5ea81dd9a42ba2c9a4b73f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ff02fb459c083ca44395eb4cc5be0926a9623ef555eeb775181d7b6f8a88461"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "918d76d5425b6e862faa3eebb5f2cf3d1ccbc28fb63eb51623bea89c4947f90a"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "unzip" => :build # for cabal install
  uses_from_macos "libffi"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Workaround to build aeson with GHC 9.14, https://github.com/haskell/aeson/issues/1155
    args = ["--allow-newer=base,containers,template-haskell"]

    system "cabal", "v2-update"
    system "cabal", "v2-install", *args, *std_cabal_v2_args, "pandoc-cli"
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

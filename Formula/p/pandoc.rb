class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://github.com/jgm/pandoc/archive/refs/tags/3.9.tar.gz"
  sha256 "d8da16e1ad1f685123fbc1a5a83b74766bcfd939dc6989484822f023bb70438f"
  license "GPL-2.0-or-later"
  compatibility_version 1
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "1f542627ebcb8ad39d56fa80f4f3300c2baab0341d9e6b0324557414790a951a"
    sha256 cellar: :any,                 arm64_sequoia: "d5f54238833f517626888a2c214dde8a94aa0f408208593e8a174fdfc2204da4"
    sha256 cellar: :any,                 arm64_sonoma:  "f953179d3ad87a50469f3761bf33666482feda48fbf3e83dab66a99403b301d0"
    sha256 cellar: :any,                 sonoma:        "e5e53a135af84a63c19f15eecb44249064e198e0f5f92964f55462beba538f2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f97d5b9bd4606fa3a400a3237eecca2bca017b8f15b5e1b307fbcd86f263a16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0d27d61a020c0b9cfe48e0837a82e59438404d13d7736e58ec7c4e61a8af464"
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

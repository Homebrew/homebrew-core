class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://github.com/jgm/pandoc/archive/refs/tags/3.2.tar.gz"
  sha256 "063984ad8b410e61e0c0f63e58c68fc1a2a3d79ba1fd73a7a7cc2db4eab0d4d9"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49d245aef672fc15018e0372a4bde4ac47b980d97e113bfe10e9f2e7f7f6fb38"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bb41cd555bbb63e15698b0c74e78bcf93f361d69cde48f6bb525a722aae9e7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be7c91ab13d7ba8c00e417227f87a41b968e44e3414cbd3312f7823bf5c7c09a"
    sha256 cellar: :any_skip_relocation, sonoma:         "f5aba45fa23a633a792a9d57401417a9ab0552a5288141d818b913d4f4f85475"
    sha256 cellar: :any_skip_relocation, ventura:        "c2698e46a109ae341fa7a3a1bd057aa6265c1dc3ffee327fcd4688be38d28a38"
    sha256 cellar: :any_skip_relocation, monterey:       "ba979193533ce35421e342f7e98b46529f4d357343d35e4d0721050d4fd0139a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ef63f9c5e7f796746dedd6c9280e80c34ceb6025fcf23d5be3ad692ed639c87"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.6" => :build

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

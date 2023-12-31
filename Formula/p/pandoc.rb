class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://github.com/jgm/pandoc/archive/refs/tags/3.1.11.tar.gz"
  sha256 "41d58aca9db2d0e3e27958f596a4cba23776ae38b0b29df5500e2bbd7fb833a9"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e7cb0e06452ef6b1b4055b562253d9193ca19cdaa8427373c41423ff6fea9813"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "068f7bbab56a583e18fbf131d25fb8e5e852393f75f59b372dee804226925bbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4eec917bc84a9b6a2d2359996b841750022e3984ff370fa4da9676a19c4c5545"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ac2c34aa9c5ff2e3f67704113146303702e7eb44b1256a7bbd95d8e04392b24"
    sha256 cellar: :any_skip_relocation, ventura:        "709626f8446da8334086ffd3a7f9c89d2123da47d5ebbc5a64a1c6ad75a46522"
    sha256 cellar: :any_skip_relocation, monterey:       "eec62355fe71b32e3c45d57405a39685d3e5bb0c53fb899692ce8c8da55548a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "352bc0503bd788c9af1519db15dd00eeb8bb2dd2d0953139b8b7fee8023ba1d6"
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

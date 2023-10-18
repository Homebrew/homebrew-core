class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://github.com/jgm/pandoc/archive/refs/tags/3.1.8.tar.gz"
  sha256 "c0bfd5973e9b335372c7e1a594499f2acc2e30e1035cc2c21bd3dc76904385a5"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b84594bbf7730905351ad6ba108f1cedce284eb5a42ccdb36e17b6484b6a19df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8c0bbeea147f617076fbaefe11a81be3e29d62cc9c089f3d4dd0ae525079f45"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4226803d0dd7b0749bb958486ee8ebefe5f1f3dfbcacef6e2e35b29bda66c372"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e6a08721e9345e0b63f15aa0a850fc54fa93bd3ee06e85023d417cc8eb545ad"
    sha256 cellar: :any_skip_relocation, sonoma:         "89dddd92e08c3f744681291415bf03da087c797e2f51e24f25ea773f1badbff6"
    sha256 cellar: :any_skip_relocation, ventura:        "a4fef7d88084e12ef4c19cc25819b3feb6572f2aefced07808ca7ff070f26472"
    sha256 cellar: :any_skip_relocation, monterey:       "48d79a10f9d5f5e5efcaf101fded87258abf9cc8c860694bd71f58a1d4ad5f8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c03daeea8b34958e7d740c9ce59f2509cfcc2ef1467591029280b03655a51f46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ba1ba7a4377d77e901d55f7d44e440f8a1d54172a1ecfff4385fcddaecb644f"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "unzip" => :build # for cabal install
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args, "pandoc-cli"
    generate_completions_from_executable(bin/"pandoc", "--bash-completion",
                                         shells: [:bash], shell_parameter_format: :none)
    man1.install "man/pandoc.1"
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

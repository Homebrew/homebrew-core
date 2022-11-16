class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.19.2/pandoc-2.19.2.tar.gz"
  sha256 "36e83694c36a5af35a4442c4d5abd4273289d9d309793466f59c1632e87d4245"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62c83be98424758ef00e8536944ec94a0b8d824fddccc11c257020e3ead5a0c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9de935646243eaca586584f3d30f93378e4adbb51008c7c25e7582ab0bebcd5d"
    sha256 cellar: :any_skip_relocation, ventura:        "2c596760cdfa6ce0618b30bf5686fd6845558076266f8337a24eed71f14e32f3"
    sha256 cellar: :any_skip_relocation, monterey:       "dff07e47cfdaedef4512aa7f12f45c449b8463ec3a296abc9b5f9b3b95945440"
    sha256 cellar: :any_skip_relocation, big_sur:        "df691fef798f877b42e8eda10d0a8ede824dff72af31702bd002942ca08a9188"
    sha256 cellar: :any_skip_relocation, catalina:       "0f636ddefda36e965678d5e1f570b1396a18aa8d0fb01bd3daf85dc7a727630c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e79774dabf337a91162206aa53b008b205cf55511366c9784adb68bdfaafff5"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "unzip" => :build # for cabal install
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
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

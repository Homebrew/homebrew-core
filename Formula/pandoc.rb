class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://github.com/jgm/pandoc/archive/refs/tags/3.1.1.tar.gz"
  sha256 "e3203bcf48fb0a91c7e9405c0e5220b251a5c2dce0b4973eeb00f16964610e8a"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71aef111f599d4babced2ab65c99e8572b8b2bd3f099fdffef443f7328afa4e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15dd1c313b9e4cd435ce85016a645c71a63b7fa6560176023136e3ffbdbe32bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "875634e8f5243436c3d4f95aa1f651ba6dc6652be482692cc38f7fa2748490c6"
    sha256 cellar: :any_skip_relocation, ventura:        "13ebbe4d501973b8a0d25a6b96cdf0a158973dd4278f52e27e55b8a5f85e03b4"
    sha256 cellar: :any_skip_relocation, monterey:       "dfe56757086705a7bd689ea55ad50f06f1bd13da806009df2db62844329abaee"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b672b11a7cf71f06e2bdb211e34ef7b712c8784e5779b94418d783c8183ae42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e156c026dc262b2167b87a83ebf0251b9b3a9fced9815d9d26b1c65f2f44f925"
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

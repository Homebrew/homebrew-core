class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://github.com/jgm/pandoc/archive/refs/tags/3.1.2.tar.gz"
  sha256 "7543c31e09ad8ccb2ce381c4039d76823865dc6c3922bfa2ed49367cf0e1fd3b"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2cfad63fa7c2c4c2f59ae493183221f14e05fb62e347f904ed57ad68bfc3b1f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e48e92276f5dc1134a68018417a8775e674d21f1e794c8e1c959963bd7f3b962"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a713600efe9be45d60d9bbd7716308da8d0fda599624ac35508ee14408efbcab"
    sha256 cellar: :any_skip_relocation, ventura:        "3559c8b72a35cbd3ae18b00ef23228224f3e1841ec6db78ac6c8b665ce028d7c"
    sha256 cellar: :any_skip_relocation, monterey:       "d4ee1633820e3a1b9b5b333a3e999948301868839ecfec30e2c766ac582fe7e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "f06ba62a81695e5aa733796cee1e3995468cd3a6b00f98913fdb47812752ed84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08d737835ae3c2981df8825e5de5e2ef3e053ce6d2c5eb2e422d23b3c6657b48"
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

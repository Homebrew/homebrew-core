require "language/haskell"

class HighlightingKate < Formula
  include Language::Haskell::Cabal

  desc "Haskell syntax highlighting library, based on the Kate editor"
  homepage "https://github.com/jgm/highlighting-kate"
  url "https://hackage.haskell.org/package/highlighting-kate-0.6.4/highlighting-kate-0.6.4.tar.gz"
  sha256 "d8b83385f5da2ea7aa59f28eb860fd7eba0d35a4c36192a5044ee7ea1e001baf"
  head "https://github.com/jgm/highlighting-kate.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c18bdbf697786c576810b4fc188afa8f7b973a75bdfad762e24c544d544baef7" => :mojave
    sha256 "5bc082453692f0d95f5e09fdcc85732b987da5a1ce33be520389e957bc2f5393" => :high_sierra
    sha256 "29ad60e21820b116e4f91c8000e2c890c081f08c4ccfc02340ca44ae9892084b" => :sierra
    sha256 "bce28e772d40cc270aa78c376a1d6fed78eaba841ca7b90e4290daad0f72d058" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build

  def install
    install_cabal_package "-f", "executable"
  end

  test do
    test_input = "*hello, world*\n"
    test_output = `/bin/echo -n "#{test_input}" | #{bin}/highlighting-kate -s markdown`
    test_output_last_line = test_output.split("\n")[-1]
    expected_last_line =
      '</style></head><body><div class="sourceCode"><pre class="sourceCode"><code class="sourceCode">' \
      "*hello, world*</code></pre></div></body>"
    assert_equal expected_last_line, test_output_last_line
  end
end

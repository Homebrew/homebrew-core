require "language/haskell"

class HighlightingKate < Formula
  include Language::Haskell::Cabal

  desc "Haskell syntax highlighting library, based on the Kate editor"
  homepage "https://github.com/jgm/highlighting-kate"
  url "https://hackage.haskell.org/package/highlighting-kate-0.6.4/highlighting-kate-0.6.4.tar.gz"
  sha256 "d8b83385f5da2ea7aa59f28eb860fd7eba0d35a4c36192a5044ee7ea1e001baf"

  head "https://github.com/jgm/highlighting-kate.git"

  bottle do
    sha256 "30eb74e8f7dbc3ab83437302d9f69be46dca325886f4aaa9e462a7dc1d210d79" => :sierra
    sha256 "f15b73e74530813a984c842b8f6982ec7eabfed10c0cf4e98128f752bd7404a4" => :el_capitan
    sha256 "93a41cef9345cbb6ce2d55ff97f5fe5e8c02ab3d51814d0783372b8e3ad946f5" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package "-f executable"
  end

  test do
    test_input = "*hello, world*\n"
    test_output = `/bin/echo -n "#{test_input}" | #{bin}/highlighting-kate -s markdown`
    test_output_last_line = test_output.split("\n")[-1]
    expected_last_line = '</style></head><body><div class="sourceCode"><pre class="sourceCode"><code class="sourceCode">*hello, world*</code></pre></div></body>'
    assert_equal expected_last_line, test_output_last_line
  end
end

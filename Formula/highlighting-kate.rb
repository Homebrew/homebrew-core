require "language/haskell"

class HighlightingKate < Formula
  include Language::Haskell::Cabal

  desc "Haskell syntax highlighting library, based on the Kate editor"
  homepage "https://github.com/jgm/highlighting-kate"
  url "https://hackage.haskell.org/package/highlighting-kate-0.6.4/highlighting-kate-0.6.4.tar.gz"
  sha256 "d8b83385f5da2ea7aa59f28eb860fd7eba0d35a4c36192a5044ee7ea1e001baf"

  head "https://github.com/jgm/highlighting-kate.git"

  bottle do
    sha256 "a0699b292e4520227f415ffa06f58e696be0104b11b7f147de435f499a9fc0b4" => :sierra
    sha256 "ba7ea24cd3d9aeb3aa45b2e498afedbf8dc338cc1dc81477a87aaaf124e73c6e" => :el_capitan
    sha256 "2164fa2319197e55eed8f57e1e78870ec8a58fc412e6594526ec4ff6911a3146" => :yosemite
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

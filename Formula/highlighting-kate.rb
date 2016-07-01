require "language/haskell"

class HighlightingKate < Formula
  include Language::Haskell::Cabal

  desc "Haskell syntax highlighting library, based on the Kate editor"
  homepage "https://github.com/jgm/highlighting-kate"
  url "https://hackage.haskell.org/package/highlighting-kate-0.6.2.1/highlighting-kate-0.6.2.1.tar.gz"
  sha256 "62af544964cb9d019baf1c81e28f8a747800c581787812a3b374e2f0a4209135"

  head "https://github.com/jgm/highlighting-kate.git"

  bottle do
    sha256 "db900521259bce9e3c45dc26e2aadcd67e50fb296984feaf22183718118cd6e8" => :el_capitan
    sha256 "8c5bc6ae824ed2a8ed8661417e1c893bb8500f20e0160f958ba5fd49e99ac0f5" => :yosemite
    sha256 "affa1c557573dd839262a7b8dc1c7b895780115785038876a4fadb94a818e758" => :mavericks
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

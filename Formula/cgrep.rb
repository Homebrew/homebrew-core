require "language/haskell"

class Cgrep < Formula
  include Language::Haskell::Cabal

  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://hackage.haskell.org/package/cgrep-6.6.13/cgrep-6.6.13.tar.gz"
  sha256 "b10853efadd6e75395ca92ba2c7ac71ba137496f1844b79048db42f74da04931"
  head "https://github.com/awgn/cgrep.git"

  bottle do
    sha256 "dabd94ad8b75860ed63eb6ed8621b84f91c1c61935d414d38b903c6ac23a7acf" => :el_capitan
    sha256 "d0e7c38a6d5f18a367f6447fa7e82754b16948364a0ffe10c3fda499bb9d5b89" => :yosemite
    sha256 "094b58255baa7afc40efcfe3e12c21b5fa24a6624aec4e907162b9bcdd6fc1cd" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pcre"

  def install
    install_cabal_package
  end

  test do
    path = testpath/"test.rb"
    path.write <<-EOS.undent
      # puts test comment.
      puts "test literal."
    EOS

    assert_match ":1",
      shell_output("script -q /dev/null #{bin}/cgrep --count --comment test #{path}")
    assert_match ":1",
      shell_output("script -q /dev/null #{bin}/cgrep --count --literal test #{path}")
    assert_match ":1",
      shell_output("script -q /dev/null #{bin}/cgrep --count --code puts #{path}")
  end
end

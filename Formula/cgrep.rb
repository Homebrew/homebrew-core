require "language/haskell"

class Cgrep < Formula
  include Language::Haskell::Cabal

  desc "Context-aware grep for source code"
  homepage "https://github.com/awgn/cgrep"
  url "https://hackage.haskell.org/package/cgrep-6.6.16/cgrep-6.6.16.tar.gz"
  sha256 "7161e331f409ee95abfab14f720ad300ce4c9bd37a9fae74de6643c0f30b134b"
  head "https://github.com/awgn/cgrep.git"

  bottle do
    sha256 "b28db131ec36e853e5bbfba8a49eb9bc4244d359467c9d01234204f7d8aa2bc4" => :sierra
    sha256 "98d4ba0d26067ecec668a5e473f647cab473f64ebd4e2bf4c4188825258aae74" => :el_capitan
    sha256 "e9798fce89cacdbd455abce2671577cbc1499fb5dc27910b3f446dfe96c8b6cb" => :yosemite
    sha256 "b31b3a173ef35d52dc04228605d3f457f68cdb964926110afcd3b163da7292e6" => :mavericks
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

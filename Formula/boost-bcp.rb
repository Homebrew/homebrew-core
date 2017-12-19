class BoostBcp < Formula
  desc "Utility for extracting subsets of the Boost library"
  homepage "https://www.boost.org/doc/tools/bcp/"
  url "https://dl.bintray.com/boostorg/release/1.66.0/source/boost_1_66_0.tar.bz2"
  sha256 "5721818253e6a0989583192f96782c4a98eb6204965316df9f5ad75819225ca9"
  head "https://github.com/boostorg/boost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd37ef056378e4628242b98e1b8ac8c0d867c9b99db357f463910009166c4ba3" => :high_sierra
    sha256 "2f9715e15a784c42c02d3e96bbebe5cab5bff01191e63db1649bb4cd529e7fdc" => :sierra
    sha256 "0479bb9b6002bf3c8f0e4063392f67850f34602826d2b3ffccf580509d48d37f" => :el_capitan
    sha256 "eb23497221bd792d1474b2c86e270a492266ea416e33c7bcfe678b4af0581eea" => :yosemite
  end

  depends_on "boost-build" => :build

  def install
    cd "tools/bcp" do
      system "b2"
      prefix.install "../../dist/bin"
    end
  end

  test do
    system bin/"bcp", "--help"
  end
end

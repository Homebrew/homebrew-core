class Depqbf < Formula
  desc "Solver for quantified boolean formulae (QBF)"
  homepage "https://lonsing.github.io/depqbf/"
  url "https://github.com/lonsing/depqbf/archive/version-5.0.tar.gz"
  sha256 "9a4c9a60246e1c00128ae687f201b6dd309ece1e7601a6aa042a6317206f5dc7"
  head "https://github.com/lonsing/depqbf.git"

  bottle do
    cellar :any
    revision 1
    sha256 "400d0d40ad053e45d27c5968f7448664543ed1824d03bb6d0508fa619ad8d7a5" => :el_capitan
    sha256 "8dfd654775860b5d76d7f8d1938ec3b3a497f05deb7995907b0772da9670f85e" => :yosemite
    sha256 "0bf4fa80296fc46ad3ef4956d4b238a18d7ad0390a67f3bb30d84d93faf97c59" => :mavericks
  end

  def install
    # Fixes "ld: unknown option: -soname"
    # Reported 5 Sep 2016 https://github.com/lonsing/depqbf/issues/8
    inreplace "makefile" do |s|
      s.gsub! "-Wl,-soname,libqdpll.so.$(MAJOR)", ""
      s.gsub! ".so.$(VERSION)", ".$(VERSION).dylib"
    end

    system "make"
    bin.install "depqbf"
    lib.install "libqdpll.a", "libqdpll.1.0.dylib"
  end

  test do
    system "#{bin}/depqbf", "-h"
  end
end

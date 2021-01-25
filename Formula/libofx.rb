class Libofx < Formula
  desc "Library to support OFX command responses"
  homepage "https://libofx.sourceforge.io"
  url "https://downloads.sourceforge.net/project/libofx/libofx/libofx-0.10.0.tar.gz"
  sha256 "f11f46d91573e7d0964eb796c4dcaa33218ede8319b77b817356cf54aaa7bbcc"
  license "GPL-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/libofx[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 "03a456e08ca084e4e35eb3b54c839d8b6b8428d8b997bba47c049843c80a969f" => :big_sur
    sha256 "d6334a066f55eb6d54633ef7f297c91a23df73aaa804b3ecb66773e56741f60e" => :arm64_big_sur
    sha256 "7938515e518b14d4d6c177640ab7246018b92977013825f2107ef17532c90d34" => :catalina
    sha256 "d2e77015c1d6d7bc018a14cd0a7bb6ad54074619ffa41956d64aab03c713673c" => :mojave
  end

  depends_on "open-sp"

  def install
    opensp = Formula["open-sp"]
    system "./configure", "--disable-dependency-tracking",
                          "--with-opensp-includes=#{opensp.opt_include}/OpenSP",
                          "--with-opensp-libs=#{opensp.opt_lib}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "ofxdump #{version}", shell_output("#{bin}/ofxdump -V").chomp
  end
end

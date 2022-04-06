class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap_2.8.121.zip"
  sha256 "d5a66b9d5189143a6adba757a085f84d3c31c03b2948939cf99851003a2934a8"
  license any_of: ["GPL-2.0-or-later", "gSOAP-1.3b"]

  livecheck do
    url :stable
    regex(%r{url=.*?/gsoap[._-]v?(\d+(?:\.\d+)+)\.zip}i)
  end

  bottle do
    sha256 arm64_monterey: "6c9763446f8b08409976e6c588f87be2f8849889a3e8602953c5785351bd6a0e"
    sha256 arm64_big_sur:  "87fda0d44082a6c1e33f06d619c129d533805d58da44f9519e5735a824a5a6b8"
    sha256 monterey:       "748387f41ec885ef826bae8e3bd1c9c5650345b003c4d2c03d9c2446911bb36c"
    sha256 big_sur:        "1ed9ba760001cf9fb5c28ac118f8efcc57d3819b26c0fc54e01356c7906ab36a"
    sha256 catalina:       "4481fc46d1b241cce9f5cf30024e2eb6b386a7d3dfe52e7d2bf40132094bb017"
    sha256 x86_64_linux:   "a4774948dcd4b77d5c97193962565c7b25b5b8143415d89076ccedb540936f2e"
  end

  depends_on "autoconf" => :build
  depends_on "openssl@1.1"

  uses_from_macos "bison"
  uses_from_macos "flex"
  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/wsdl2h", "-o", "calc.h", "https://www.genivia.com/calc.wsdl"
    system "#{bin}/soapcpp2", "calc.h"
    assert_predicate testpath/"calc.add.req.xml", :exist?
  end
end

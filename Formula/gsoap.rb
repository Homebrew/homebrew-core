class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap_2.8.122.zip"
  sha256 "3eb8486c986b44071bb5f19ef7b990791f819bb267c0bf640e95bd991070fad8"
  license any_of: ["GPL-2.0-or-later", "gSOAP-1.3b"]

  livecheck do
    url :stable
    regex(%r{url=.*?/gsoap[._-]v?(\d+(?:\.\d+)+)\.zip}i)
  end

  bottle do
    sha256 arm64_monterey: "90aa52dc764f209371e51d0a9a053665e50d75be044a77aee6f0aeb1c18ddfff"
    sha256 arm64_big_sur:  "f86257224428197c9f5f670e84fc3b06caab7ce750c9bb56218a1f9db35e7067"
    sha256 monterey:       "b5adbd159045cd3c4d93d0a03ae7246ca10542de74524fa6055d8cfe938a368f"
    sha256 big_sur:        "82a0f4682aa0ecdfbf8827269d9de4b6bfb21152b42a74c70b7544807e536168"
    sha256 catalina:       "3fe7ba78fa02cb3235c44d42193e9bd7330856c4756577296676f6bc160827da"
    sha256 x86_64_linux:   "b8c787ce66b49632207e4828292b3b032f0ecea3c65aea329185018a4b2688fd"
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

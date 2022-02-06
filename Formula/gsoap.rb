class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap_2.8.119.zip"
  sha256 "8997c43b599a2bfe4a788e303a5dd24bbf5992fd06d56f606ca680ca5b0070cf"
  license any_of: ["GPL-2.0-or-later", "gSOAP-1.3b"]

  livecheck do
    url :stable
    regex(%r{url=.*?/gsoap[._-]v?(\d+(?:\.\d+)+)\.zip}i)
  end

  bottle do
    sha256 arm64_monterey: "327b6775f26bece57bef8c448a937e9baa3d3832986d2a16b2486a4c3f3a7869"
    sha256 arm64_big_sur:  "6e80b1fbc9a49b16cb50447ddbf9e6a97aa7c2ec885608dd8e6463cbf22c7903"
    sha256 monterey:       "d05d4a63c86c3ec5e84bffc31f8d2d5cd9374fb1da29e4da4e67a535791793db"
    sha256 big_sur:        "768b9f385bdcf8c68dddac2ac453471b71146fa4003ea6360339007b40097e2c"
    sha256 catalina:       "5e21be665e7eb46cfe722f72639d6330f14cd795efe52c2f5be69b6dfac8a60f"
    sha256 x86_64_linux:   "16a8adc9b0c571760523bd9b9108ef3d0a87d0147560d1c740648d880df727c2"
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

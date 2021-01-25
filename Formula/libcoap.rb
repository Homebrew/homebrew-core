class Libcoap < Formula
  desc "Lightweight application-protocol for resource-constrained devices"
  homepage "https://github.com/obgm/libcoap"
  url "https://github.com/obgm/libcoap/archive/v4.2.1.tar.gz"
  sha256 "29a0394a265d3febee41e5e2dc03d34292a0aede37f5f80334e529ac0dab2321"
  license "BSD-2-Clause"

  bottle do
    cellar :any
    sha256 "f57bd53021361886f6928bbb0156dd642bd39dbdd459e5a69951560e4cc47050" => :big_sur
    sha256 "d8f66e021f0ed8d227696e8e37d97085a77624aaa391fdd63f4f00326a101289" => :arm64_big_sur
    sha256 "344f2a098d9f1767d50135fbf4ae3bdf893a079ebf8a54f248811673fa437e39" => :catalina
    sha256 "012f1efcb1655479c531df4db98eb481d83971751edffb99b4ca8c50592cd27c" => :mojave
    sha256 "a68df19a4ca87c677173c14b534848592bb35e46a715ca066bcd114f8c735236" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "doxygen" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1" if MacOS.version <= :sierra

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-examples",
                          "--disable-manpages"
    system "make"
    system "make", "install"
  end
end

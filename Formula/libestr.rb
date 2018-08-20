class Libestr < Formula
  desc "C library for string handling (and a bit more)"
  homepage "http://libestr.adiscon.com"
  url "http://libestr.adiscon.com/files/download/libestr-0.1.10.tar.gz"
  sha256 "bd655e126e750edd18544b88eb1568d200a424a0c23f665eb14bbece07ac703c"

  bottle do
    cellar :any
    sha256 "6dd3aa33fa74f62679745de0a6e934231b3eba2c453a4d552612336ad3d851fa" => :mojave
    sha256 "0413d6b2e350cf0b96ac51277aea7cc138ce848b81091e7172c4cbbb6efd1102" => :high_sierra
    sha256 "180b2620f9ba546d062835b15753236a616ecd53fa01bacb07bf6368d4825b64" => :sierra
    sha256 "a95f0ed48b7a7879128ea8b7d1dfac5d6c736ee504d88a65155c040eff6ea134" => :el_capitan
    sha256 "b6378b804c98be7a85e665f7f98035446941720f2ae9de94cd1cfedd607a5e10" => :yosemite
    sha256 "5215ffe64cf57a7c95561588e8e117983419fece70fbc3c61d26099a249cf098" => :mavericks
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "stdio.h"
      #include <libestr.h>
      int main() {
        printf("%s\\n", es_version());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lestr", "-o", "test"
    system "./test"
  end
end

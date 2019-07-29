class Libmodbus < Formula
  desc "Portable modbus library"
  homepage "https://libmodbus.org/"
  url "https://libmodbus.org/releases/libmodbus-3.1.4.tar.gz"
  mirror "https://librecmc.org/librecmc/downloads/sources/v1.3.4/libmodbus-3.1.4.tar.gz"
  sha256 "c8c862b0e9a7ba699a49bc98f62bdffdfafd53a5716c0e162696b4bf108d3637"

  bottle do
    cellar :any
    sha256 "5fb8b99f7f627463dfc980ca02e9d0edc16c8d93238395e980c38b928682eb58" => :mojave
    sha256 "a3c060ca8f3d80e7e2a42f2a87ffbeb157105632e5e2a9a107e4c0f3523199d3" => :high_sierra
    sha256 "4cf11a1c8739b213105a05bbaf49331b35b226dd90191d6a494898b3021aba6e" => :sierra
    sha256 "3335403ddd6011372473fe338ae2cac2ab7f168f214a0624620aa9c1575477be" => :el_capitan
    sha256 "0c3f25dc4288d69acc7abc8cd3e46915c76c7ea50d7ef62893a36981d6f926a3" => :yosemite
    sha256 "bff065c529bf0ab2cbac0fe93336b7106e08d02926c57ccb949f9c7bca025d23" => :mavericks
  end

  head do
    url "https://github.com/stephane/libmodbus.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"hellomodbus.c").write <<~EOS
      #include <modbus.h>
      #include <stdio.h>
      int main() {
        modbus_t *mb;
        uint16_t tab_reg[32];

        mb = 0;
        mb = modbus_new_tcp("127.0.0.1", 1502);
        modbus_connect(mb);

        /* Read 5 registers from the address 0 */
        modbus_read_registers(mb, 0, 5, tab_reg);

        void *p = mb;
        modbus_close(mb);
        modbus_free(mb);
        mb = 0;
        return (p == 0);
      }
    EOS
    system ENV.cc, "hellomodbus.c", "-o", "foo", "-L#{lib}", "-lmodbus",
      "-I#{include}/libmodbus", "-I#{include}/modbus"
    system "./foo"
  end
end

class Libmodbus < Formula
  desc "Portable modbus library"
  homepage "https://libmodbus.org/"
  url "https://libmodbus.org/releases/libmodbus-3.1.6.tar.gz"
  sha256 "d7d9fa94a16edb094e5fdf5d87ae17a0dc3f3e3d687fead81835d9572cf87c16"

  bottle do
    cellar :any
    sha256 "dd69c46175e27a8a79938c12dbdcbdb67d3d1b74a0c4ad067a394eaa7a5869ca" => :catalina
    sha256 "0dd32373b5988d09317728357780b3cdc54cad290afcb51b390f33a50fa653e0" => :mojave
    sha256 "d821c77d787cf51c96811c37374d5cc42c7948636c84d7b7b6251a7e0afa29a0" => :high_sierra
    sha256 "462dd4e48e87bab1e48ef64f3f3a907392994a9f8c0753c8b739ca5207882b32" => :sierra
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

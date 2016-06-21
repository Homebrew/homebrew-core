class Libmodbus < Formula
  desc "Portable modbus library"
  homepage "http://libmodbus.org"
  url "http://libmodbus.org/releases/libmodbus-3.1.4.tar.gz"
  mirror "https://sources.lede-project.org/dl/dl/libmodbus-3.1.4.tar.gz"
  sha256 "c8c862b0e9a7ba699a49bc98f62bdffdfafd53a5716c0e162696b4bf108d3637"

  bottle do
    cellar :any
    revision 1
    sha256 "6922fc507a0035f3fc51682956775576ea5cd150df59f3d7a90c7b109174e558" => :el_capitan
    sha256 "1fc2e425a2d7c42bd35364ee3ca41592940e6de7cab628824d0c5dd2cdcb98c6" => :yosemite
    sha256 "5633226af76d9e9b5eadc0dfa541da123c2ef9ac7dbb70b23dbbce3799581f17" => :mavericks
    sha256 "d316924c6dc8abd13c2e171577888c0ac569c426a6c32bd511531beb4da42758" => :mountain_lion
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
    (testpath/"hellomodbus.c").write <<-EOS.undent
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
    system ENV.cc, "hellomodbus.c", "-o", "foo", "-lmodbus",
      "-I#{include}/libmodbus", "-I#{include}/modbus"
    system "./foo"
  end
end

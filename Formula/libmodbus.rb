class Libmodbus < Formula
  desc "Portable modbus library"
  homepage "https://libmodbus.org/"
  url "https://github.com/stephane/libmodbus/archive/v3.1.7.tar.gz"
  sha256 "af8ade1eec30fe3dc6ddf8f711b37f9a931532287f39a40f54e6f475402df389"
  license "LGPL-2.1-or-later"
  head "https://github.com/stephane/libmodbus.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fc2d5dcb26e376825f443f62e519611a4b41ccdffc41f2548845299de8d48874"
    sha256 cellar: :any,                 arm64_big_sur:  "e244f011a09c4544dfcff26ca37a5b1ac14437f265dbba0ffaf3a5828a3f247c"
    sha256 cellar: :any,                 monterey:       "21609d282cb0f2820eca845eacd27646c6094d4f31befb422c2bb9cc127cf414"
    sha256 cellar: :any,                 big_sur:        "d5997eb25c8f5c97149ed2c1b1955186f89683e58662d9f0298546666bb5bb2b"
    sha256 cellar: :any,                 catalina:       "a721d3fe6901bbe5905610361c34c08a2b429e4fa99deb7c4db36553781d5092"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57a694edda6a85dc6f7c8619074690825aab88a631016f270486d4e2c350994f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
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

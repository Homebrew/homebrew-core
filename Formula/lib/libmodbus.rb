class Libmodbus < Formula
  desc "Portable modbus library"
  homepage "https://libmodbus.org/"
  url "https://github.com/stephane/libmodbus/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "0c61007b2815daf452618f8b877d15cdcd376b71ad5dbd06b330d70f53b2ccaa"
  license "LGPL-2.1-or-later"
  head "https://github.com/stephane/libmodbus.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5073559c9b2644170da1966b1a9e493475eb09a7076bb95bd00fe09055a235f7"
    sha256 cellar: :any, arm64_sequoia: "4fbc2fde606f9b205870d1b8463a059a3f49594386b52f4a0cd5f24d0e59bcf1"
    sha256 cellar: :any, arm64_sonoma:  "cd29b5c859733673c18dc437c8be755676b16d10d83946345aa1ef7184ee0794"
    sha256 cellar: :any, sonoma:        "08432d0e74365d700fa2c14cf547f3071e1c2512a41355322120ab87815ad88d"
    sha256 cellar: :any, arm64_linux:   "a69ecfd9d3c85d75c5f4a1d85c6ca0a07f28ec24d19aaff740f5e113f652d3aa"
    sha256 cellar: :any, x86_64_linux:  "ced33328883e5198fd63e8b4206b8f0e1f52b8151b6320d05ee87e986a6080b3"
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
    (testpath/"hellomodbus.c").write <<~C
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
    C
    system ENV.cc, "hellomodbus.c", "-o", "foo", "-L#{lib}", "-lmodbus",
      "-I#{include}/libmodbus", "-I#{include}/modbus"
    system "./foo"
  end
end

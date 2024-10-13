class Libmodbus < Formula
  desc "Portable modbus library"
  homepage "https://libmodbus.org/"
  url "https://github.com/stephane/libmodbus/archive/refs/tags/v3.1.10.tar.gz"
  sha256 "e93503749cd89fda4c8cf1ee6371a3a9cc1f0a921c165afbbc4fd96d4813fa1a"
  license "LGPL-2.1-or-later"
  head "https://github.com/stephane/libmodbus.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "9e12029c9ec0782bd5fac20b46e2521b604cab4f73f387660265a1c4987b12da"
    sha256 cellar: :any,                 arm64_sonoma:   "3b9c2f9582962d98481e78df8ee431118ca2725cd6db782087f99f9e4e43656d"
    sha256 cellar: :any,                 arm64_ventura:  "585781b5c3f26d145faf3b0c06e58bd9789ace242f6631689edfc4dee3ab5b1f"
    sha256 cellar: :any,                 arm64_monterey: "782038c57d82103f1c245d8d76f9acec4fd25b9bbb38c90fc8558c63ff00ddb5"
    sha256 cellar: :any,                 arm64_big_sur:  "870b055e0964bde546ca96ac9a381f6d47de22e1bda504e9332800eefa2478bf"
    sha256 cellar: :any,                 sonoma:         "0cd572e641242012940e0a66c4a0133b348e506e908c9d847f4929290a22e999"
    sha256 cellar: :any,                 ventura:        "20eb8bf548c71959c9269981ec3d95b30871cca5074b32d60780356ee2930bb2"
    sha256 cellar: :any,                 monterey:       "aaf518a16cbfdcc17b4355d4edb497607363b3b8f78d57e5b1c7d5af67588532"
    sha256 cellar: :any,                 big_sur:        "25ad3c494672c5006f15cb27bd69cedb91d5a14ada0f52a4e8c622dbdec76d6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b04b946ea68e47136a06d01734d22e1a6c6eb9ed21514394f28f9b30364e1f54"
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

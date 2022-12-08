class Libmodbus < Formula
  desc "Portable modbus library"
  homepage "https://libmodbus.org/"
  url "https://github.com/stephane/libmodbus/archive/v3.1.10.tar.gz"
  sha256 "e93503749cd89fda4c8cf1ee6371a3a9cc1f0a921c165afbbc4fd96d4813fa1a"
  license "LGPL-2.1-or-later"
  head "https://github.com/stephane/libmodbus.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3ef59ed18d26450a46cb7d24014d623763109ab9b9f80ab5cd4e8236971531a7"
    sha256 cellar: :any,                 arm64_monterey: "cfb0e36dc0fd0a7bb191c5fe5ef6e0253176ad5c1d284e3e059728302251cb38"
    sha256 cellar: :any,                 arm64_big_sur:  "57ece84bf699755c6eeaa4f0fb21a098e922db9d3839bdf32634c08201dce4fd"
    sha256 cellar: :any,                 ventura:        "f95e87950e5b886687087b3e9fa490a07b97da6a47405d0ed081fa50a12e250c"
    sha256 cellar: :any,                 monterey:       "1a042509b854e844cf12aa28fa56cf4bfb274c28ef90eacd41a91219b5c6d9c1"
    sha256 cellar: :any,                 big_sur:        "8dfd7fbbeb7810af481d97892f37ed23074de80c60f01506e4b975ccdcf20132"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "369ce1d96b985d316ae42ff23e828ffbbc816528243e315cf8a17561faad3880"
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

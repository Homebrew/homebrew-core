class Libmodbus < Formula
  desc "Portable modbus library"
  homepage "https://libmodbus.org/"
  url "https://github.com/stephane/libmodbus/archive/v3.1.9.tar.gz"
  sha256 "75ac07f49b138a636c65980b92a4792290ee901503c324f2f4e23592bfa036c0"
  license "LGPL-2.1-or-later"
  head "https://github.com/stephane/libmodbus.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "99fde44af019a19d4c83f5cd238fabfc9ab21e5398931fcec84b2073304f481a"
    sha256 cellar: :any,                 arm64_monterey: "74a9c2d2818aaa2c2eeeb562065a7adfdbe6d74a57efdcdf149216ac55bb5edb"
    sha256 cellar: :any,                 arm64_big_sur:  "dd7d87fb14eb1bef41df46f4c19bfd234f299ccec330d2ea00f81fdcd3b79a0d"
    sha256 cellar: :any,                 ventura:        "3373ab1d921dc9728a00788c591f8dc11903f15ba1108c9501cd217a1b2a4b69"
    sha256 cellar: :any,                 monterey:       "32f16b06488fbf761e3573c24648f30f6d436c723773e595f62fdaa123abf153"
    sha256 cellar: :any,                 big_sur:        "51cc6f2ded4c476a96e90884c182086a8c1de60155ec6c0f3d9380a0e7ca468e"
    sha256 cellar: :any,                 catalina:       "2ae1fc0a944674ae60fdae50a7f68f96eff57b90c73a2a5d241da50393777087"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74626e6ae591eb41843dfcbee39ac7a63c4e99050c2365ae70d1a5fbf55a108f"
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

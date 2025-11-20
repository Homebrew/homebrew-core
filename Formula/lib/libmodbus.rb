class Libmodbus < Formula
  desc "Portable modbus library"
  homepage "https://libmodbus.org/"
  url "https://github.com/stephane/libmodbus/archive/refs/tags/v3.1.11.tar.gz"
  sha256 "8a750452ef86a53de6cec6fbca67bd5be08d0a1e87278a422fbce3003fd42d99"
  license "LGPL-2.1-or-later"
  head "https://github.com/stephane/libmodbus.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "971554850e99ed7c81ad315013025f55d1eccc3c9ea7912d1f62372b72725435"
    sha256 cellar: :any,                 arm64_sequoia: "2bb927ed4609da5405a486b49ef592e66c34d3a4af2c676149a77a0c2a0e05fe"
    sha256 cellar: :any,                 arm64_sonoma:  "6609f407786750265664ef7c244df8e4ba004c7dea7c9d101c72d35815072a1c"
    sha256 cellar: :any,                 arm64_ventura: "37c9a7ede2185ce78de56d89fb0f18ff44cd3f7c3d172081045d7df5b3ba5de3"
    sha256 cellar: :any,                 sonoma:        "465170cd461f3cc3b33f1840a3a0d95a0897557d2b266c706f899853adca4be0"
    sha256 cellar: :any,                 ventura:       "8a3de10bb6cd6380eed6477580643b957f9a75bd9e6dd8da40380eebd80f94e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc6f0b3c9bf53b24831a826ba42869840425900a01c5f62fff0fb3be2246a0ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d420d004141628626487faaf267f93d2cfb99b1971dbaa20b9848db23ce798e"
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

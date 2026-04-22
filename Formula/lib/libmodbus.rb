class Libmodbus < Formula
  desc "Portable modbus library"
  homepage "https://libmodbus.org/"
  url "https://github.com/stephane/libmodbus/archive/refs/tags/v3.1.12.tar.gz"
  sha256 "4151177f5223625c6be94230affb096aa8b1cdb0df00fe1f74ce53878a25d15d"
  license "LGPL-2.1-or-later"
  head "https://github.com/stephane/libmodbus.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a19a1e7794e92ff2457f53854efe9f25af59eb226c3e9894434f0bba430af5c5"
    sha256 cellar: :any,                 arm64_sequoia: "2e81e96a86fc637f9beb11bbc671d2f8ce779232959c21425f4d809532566200"
    sha256 cellar: :any,                 arm64_sonoma:  "ee16ccee86da68d0902e0d539b4ec259851c5c06751d627a3df3c62e57b97644"
    sha256 cellar: :any,                 sonoma:        "f95283005a391bc212c9492d0177d7a9532c09c05e9d7c8d17056ab61d456593"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8bbf29d0d6b2a53ddc10fae268b78d191aafce3788209174754fd037e100bc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca28017a4ab526343a25a5f36a5f441fc7512ff6daf7089a7a0e611a6813c095"
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

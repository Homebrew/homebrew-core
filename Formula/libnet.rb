class Libnet < Formula
  desc "C library for creating IP packets"
  homepage "https://github.com/sam-github/libnet"
  url "https://github.com/sam-github/libnet/archive/libnet-1.2.tar.gz"
  sha256 "a4fd8022abc9a279fa38abb5409d232d3969cce86cf67e64ea72ca264af71e05"

  bottle do
    cellar :any
    rebuild 1
    sha256 "acafac211b84c80292796e6ee62f0ab92ef047a771b0e76ad31b359cbaa7b936" => :mojave
    sha256 "2adca799087317fa0c93f750239e8be5a746fc0369bd6e7bbb6bc2d79ebe5f5d" => :high_sierra
    sha256 "2b31af371d3516aae63436e1c12b40f474fd69b1126e6d75bed9d4853fbd4ffc" => :sierra
    sha256 "26a496e3607f2639592617769522a790259c834f91c05d91721331fe6f1ad0c4" => :el_capitan
    sha256 "4203e91b8334689591d1dcec4e2f11625b035dbef078dd7f63121dbf3959e69b" => :yosemite
    sha256 "fd35c44586c926e10d9cb616e2b33594cb553329735ff2fe9130adfa8ccf17da" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "doxygen" => :build
  depends_on "libtool" => :build

  def install
    chdir "libnet" do
      system "autoreconf", "-fvi"
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}"
      inreplace "src/libnet_link_bpf.c", "#include <net/bpf.h>", "" # Per MacPorts
      system "make -C doc doc"
      ENV.deparallelize { system "make", "install" }
    end
  end
end

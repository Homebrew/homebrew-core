class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.3.1/nvc-1.3.1.tar.gz"
  sha256 "f578d3c631d58fdff7981a89bafb75554ea5651a44bbb1218037f57281c7350b"

  bottle do
    sha256 "da804dc99d5e2cde107690f13610b20aed1627314191281e0bd5c2f89799ceb5" => :high_sierra
    sha256 "9e585721435432ac02cf01a2304c2a7c2c6c69c02413cace1beed2fa5d3552f1" => :sierra
    sha256 "f8b422fba6185748fe3580e26e0868b9830d42dfbee4d23b34a101869b8c9d39" => :el_capitan
  end

  head do
    url "https://github.com/nickg/nvc.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "llvm" => :build
  depends_on "check" => :build

  resource "vim-hdl-examples" do
    url "https://github.com/suoto/vim-hdl-examples.git",
        :revision => "c112c17f098f13719784df90c277683051b61d05"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./tools/fetch-ieee.sh"
    system "./configure", "--with-llvm=#{Formula["llvm"].opt_bin}/llvm-config",
                          "--prefix=#{prefix}",
                          "--with-system-cc=/usr/bin/clang"
    system "make"
    system "make", "install"
  end

  test do
    resource("vim-hdl-examples").stage testpath
    system "#{bin}/nvc", "-a", "#{testpath}/basic_library/very_common_pkg.vhd"
  end
end

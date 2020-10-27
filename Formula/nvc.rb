class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.5.0/nvc-1.5.tar.gz"
  sha256 "4da984ba95eb3b8dd2893fb7a676675de869ff114b827a9f5490dfd54bc95fcb"
  license "GPL-3.0"
  revision 1

  bottle do
    sha256 "7ba6e4a374fa45ac6727a3a94b68ec1e317989999aeace6e16e2d2374f1adef9" => :catalina
    sha256 "f7096c9a1f5430b7540a5384c21548e3d58937a571b894362d00326400ec52cb" => :mojave
    sha256 "9235685aba9cdb880d6d76336fa94e918762bbd5e7de2c150a5ab4d887ec2b74" => :high_sierra
  end

  head do
    url "https://github.com/nickg/nvc.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  # llvm 8+ is not supported https://github.com/nickg/nvc/commit/c3d1ae5700cfba6070293ad1bb5a6c198c631195
  depends_on "llvm@7"

  resource "vim-hdl-examples" do
    url "https://github.com/suoto/vim-hdl-examples.git",
        revision: "c112c17f098f13719784df90c277683051b61d05"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./tools/fetch-ieee.sh"
    system "./configure", "--with-llvm=#{Formula["llvm@7"].opt_bin}/llvm-config",
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

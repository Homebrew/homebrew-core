class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.5.0/nvc-1.5.tar.gz"
  sha256 "4da984ba95eb3b8dd2893fb7a676675de869ff114b827a9f5490dfd54bc95fcb"
  license "GPL-3.0"
  revision 1

  bottle do
    sha256 "fa793a160f27114d00283841aa3b62f84fd96294ab32edec126b2394b2922e17" => :catalina
    sha256 "7956048641f3bb90fedd773aa989ec8539ee4d8e896ebc8df1e9b73a5548a35a" => :mojave
    sha256 "fa79164877d0f31bc605aca1bb2d4fea9f97dc22e83ece3c73b231529dfd4820" => :high_sierra
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
        :revision => "c112c17f098f13719784df90c277683051b61d05"
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

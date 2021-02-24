class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.5.0/nvc-1.5.tar.gz"
  sha256 "4da984ba95eb3b8dd2893fb7a676675de869ff114b827a9f5490dfd54bc95fcb"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 arm64_big_sur: "76441135ec856345e43510a1a7da280138a85d9c0cfee5976dd66d765d4baf4e"
    sha256 big_sur:       "1f2d64225daa270c2914bc24bf9510ee778e3760a287c9d72f1aa6e96eb9ecbe"
    sha256 catalina:      "35cf1be4eec7f103dd0d77d3a19464e7bbb745bc3dbbf04ccb0edf35ea82c734"
    sha256 mojave:        "512571d57d7e9e97199941fc0dea8347034d64f750abb000ada7ba9fa5c8f4ea"
  end

  head do
    url "https://github.com/nickg/nvc.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm"

  resource "vim-hdl-examples" do
    url "https://github.com/suoto/vim-hdl-examples.git",
        revision: "c112c17f098f13719784df90c277683051b61d05"
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

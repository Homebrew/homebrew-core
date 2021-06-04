class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.5.1/nvc-1.5.1.tar.gz"
  sha256 "2c418a19c60ee91c92865700be53907b8fbfaa3ea64bfc32aed996ed2c55df43"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_big_sur: "7c05a43adb8e06f4d7c476ee7648c98baf6cba58f964321c9d8035493168e88c"
    sha256 big_sur:       "d4064f6d3d03798588a886d0c243184169b582d1228f344c97d1d380f4ec6767"
    sha256 catalina:      "2164b0c823a884279abecb21ed79425cdc910ee472a771f99aa51c5db1134a78"
    sha256 mojave:        "e6125afeec736628f6f02f3912d8aa0c412049b07b08ca4c2f7a88ca38b194c0"
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
    system "./configure", "--with-llvm=#{Formula["llvm"].opt_bin}/llvm-config",
                          "--prefix=#{prefix}",
                          "--with-system-cc=/usr/bin/clang",
                          "--enable-vhpi"
    system "make"
    system "make", "install"
  end

  test do
    resource("vim-hdl-examples").stage testpath
    system "#{bin}/nvc", "-a", "#{testpath}/basic_library/very_common_pkg.vhd"
  end
end

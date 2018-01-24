class Openctm < Formula
  desc "File format for storing 3D triangle meshes"
  homepage "https://openctm.sourceforge.io"
  url "https://download.sourceforge.net/project/openctm/OpenCTM-1.0.3/OpenCTM-1.0.3-src.tar.bz2"
  sha256 "4a8d2608d97364f7eec56b7c637c56b9308ae98286b3e90dbb7413c90e943f1d"

  depends_on "gtk+"

  def install
    system "make", "-f", "Makefile.macosx"

    mkdir lib
    mkdir include
    mkdir bin
    mkdir man1
    system "make", "LIBDIR=#{lib}/",
                   "INCDIR=#{include}/",
                   "BINDIR=#{bin}/",
                   "MAN1DIR=#{man1}/",
                   "-f", "Makefile.macosx", "install"
  end

  test do
    system "#{bin}/ctmconv"
  end
end

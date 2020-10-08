class Fpart < Formula
  desc "Sorts file trees and packs them into bags"
  homepage "https://github.com/martymac/fpart/"
  url "https://github.com/martymac/fpart/archive/fpart-1.2.0.tar.gz"
  sha256 "ced59d68236d960473b5d9481f3d0c083f10a7be806c33125cc490ef2c1705f8"
  license "BSD-2-Clause"

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoreconf", "-i"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"myfile1").write("")
    (testpath/"myfile2").write("")
    system bin/"fpart", "-n", "2", "-o", (testpath/"mypart"), (testpath/"myfile1"), (testpath/"myfile2")
    (testpath/"mypart.0").exist?
    (testpath/"mypart.1").exist?
    !(testpath/"mypart.2").exist?
  end
end

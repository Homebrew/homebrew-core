class Ivykis < Formula
  desc "Async I/O-assisting library"
  homepage "https://sourceforge.net/projects/libivykis/"
  url "https://github.com/buytenh/ivykis/archive/v0.42.4-trunk.tar.gz"
  sha256 "b724516d6734f4d5c5f86ad80bde8fc7213c5a70ce2d46b9a2d86e8d150402b5"
  license "LGPL-2.1"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:[._-]trunk)?$/i)
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "b3a788209e93dab2e5056bacbe24b7efe5554131d9b26ace853ca68f42e9d23c" => :big_sur
    sha256 "cd87cff2d6552030ba5b277853bf4f386bc28411ca0c9283e1ed90981f0ba6aa" => :arm64_big_sur
    sha256 "5da36891f20e60db1a94b7eafeaf35605a0a4b18e833721aec01ab68399653a3" => :catalina
    sha256 "dd4fa86f2988dd4c913fc443131ce519ebf034ff492b4760f323ca663fb1744c" => :mojave
    sha256 "1409aa60298ac27959cf5370b70d158843524e5f5638e28e9607ac7e8783b11e" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test_ivykis.c").write <<~EOS
      #include <stdio.h>
      #include <iv.h>
      int main()
      {
        iv_init();
        iv_deinit();
        return 0;
      }
    EOS
    system ENV.cc, "test_ivykis.c", "-L#{lib}", "-livykis", "-o", "test_ivykis"
    system "./test_ivykis"
  end
end

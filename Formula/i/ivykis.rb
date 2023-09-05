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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "81c383eb047987000be061f4beaa4f0621900fdf299405a32bd0d875f4cb6bc8"
    sha256 cellar: :any,                 arm64_monterey: "117efe3df301c5489c623091a19c5b81957343e0fbc93da8165034772caae24a"
    sha256 cellar: :any,                 arm64_big_sur:  "cd87cff2d6552030ba5b277853bf4f386bc28411ca0c9283e1ed90981f0ba6aa"
    sha256 cellar: :any,                 ventura:        "70a2f7977517abd77a4c446196340c9a2cc41d5929df8ba79cec43265d23f7b1"
    sha256 cellar: :any,                 monterey:       "e1cdca7723759314df53420febdf1407ed1dec93b7969ce59a584b28694ab399"
    sha256 cellar: :any,                 big_sur:        "b3a788209e93dab2e5056bacbe24b7efe5554131d9b26ace853ca68f42e9d23c"
    sha256 cellar: :any,                 catalina:       "5da36891f20e60db1a94b7eafeaf35605a0a4b18e833721aec01ab68399653a3"
    sha256 cellar: :any,                 mojave:         "dd4fa86f2988dd4c913fc443131ce519ebf034ff492b4760f323ca663fb1744c"
    sha256 cellar: :any,                 high_sierra:    "1409aa60298ac27959cf5370b70d158843524e5f5638e28e9607ac7e8783b11e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0953b9d2f273aeba941031332ea3cc9233ca70d1c451026192f2f9e0d9bb408d"
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

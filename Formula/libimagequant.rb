class Libimagequant < Formula
  desc "Palette quantization library extracted from pnquant2"
  homepage "https://pngquant.org/lib/"
  url "https://github.com/ImageOptim/libimagequant/archive/2.15.1.tar.gz"
  sha256 "3a9548f99be8c3b20a5d9407d0ca95bae8b0fb424a2735a87cb6cf3fdd028225"
  license :cannot_represent

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "bef09fec647c1d4cd690a68a93e9941ed910946672346cbcfd9136e231857d15"
    sha256 cellar: :any,                 big_sur:       "0521a9c6ee13fb0859fa33c98b7dc07b552e0de9856e838fdb2b05657f24cd03"
    sha256 cellar: :any,                 catalina:      "b98776cbcd191d2db03333a3151a69d7b3d52069d59d394e47dc809ca470b450"
    sha256 cellar: :any,                 mojave:        "00fffaa6d819e9c9bb2c05c254d3a4fdb33c86ac081ec404dc9bf165cd7e9f0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f09af222755dbc2b8fc497a2e023e0aa1705a3b64d6b340b6599b0af34d8b63"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libimagequant.h>

      int main()
      {
        liq_attr *attr = liq_attr_create();
        if (!attr) {
          return 1;
        } else {
          liq_attr_destroy(attr);
          return 0;
        }
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-limagequant", "-o", "test"
    system "./test"
  end
end

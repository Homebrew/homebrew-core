class Pngxx < Formula
  desc "C++ wrapper for libpng library"
  homepage "https://www.nongnu.org/pngpp/"
  url "https://download.savannah.gnu.org/releases/pngpp/png++-0.2.10.tar.gz"
  sha256 "998af216ab16ebb88543fbaa2dbb9175855e944775b66f2996fc945c8444eee1"

  bottle do
    cellar :any_skip_relocation
    sha256 "5226334e7e4140d95289b8a56d6c5f9c1eb92f499889fc36f79d14b41528d466" => :mojave
    sha256 "5226334e7e4140d95289b8a56d6c5f9c1eb92f499889fc36f79d14b41528d466" => :high_sierra
    sha256 "8e47f0497587c61a45e78c0e75345304bc860ba56e1a272f87b2e1017dc87eef" => :sierra
  end

  depends_on "libpng"

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <png++/png.hpp>
      int main() {
        png::image<png::rgb_pixel> image(200, 300);
        if (image.get_width() != 200) return 1;
        if (image.get_height() != 300) return 2;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test"
    system "./test"
  end
end

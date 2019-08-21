class Pngxx < Formula
  desc "C++ wrapper for libpng library"
  homepage "https://www.nongnu.org/pngpp/"
  url "https://download.savannah.gnu.org/releases/pngpp/png++-0.2.10.tar.gz"
  sha256 "998af216ab16ebb88543fbaa2dbb9175855e944775b66f2996fc945c8444eee1"

  bottle do
    cellar :any_skip_relocation
    sha256 "536f9c2dd05cfd2ae8a4f7f5d0c5c38575cf91609498f98bd6c3f97c4de2c520" => :mojave
    sha256 "536f9c2dd05cfd2ae8a4f7f5d0c5c38575cf91609498f98bd6c3f97c4de2c520" => :high_sierra
    sha256 "cee110f568bae723e8e5172e8bab36c8f4c5adb8bf339a444926a572bfa13f89" => :sierra
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

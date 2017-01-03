class Devil < Formula
  desc "Cross-platform image library"
  homepage "https://sourceforge.net/projects/openil/"
  url "https://downloads.sourceforge.net/project/openil/DevIL/1.8.0/DevIL-1.8.0.tar.gz"
  sha256 "0075973ee7dd89f0507873e2580ac78336452d29d34a07134b208f44e2feb709"
  head "https://github.com/DentonW/DevIL.git"

  bottle do
    cellar :any
    sha256 "1d95bffc40243d4489ebfe8335d4eea0691b66f2f0b2ee1a5dd699632346c692" => :sierra
    sha256 "64054158e523a5f2e575301454119b3a9fd159d2941e8349c6f7effdf229ed0e" => :el_capitan
    sha256 "906a89e5b5b593260a6bbd4cbab351adee051bde3dcaec7e61db62eacbcd74bd" => :yosemite
  end

  option :universal

  depends_on "cmake" => :build
  depends_on "jasper"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"

  def install
    ENV.universal_binary if build.universal?
    cd "DevIL" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <IL/il.h>
      int main() {
        ilInit();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-I#{include}",
                    "-L#{lib}", "-lIL", "-lILU"
    system "./test"
  end
end

class Devil < Formula
  desc "Cross-platform image library"
  homepage "https://sourceforge.net/projects/openil/"
  revision 1
  head "https://github.com/DentonW/DevIL.git"

  stable do
    url "https://downloads.sourceforge.net/project/openil/DevIL/1.8.0/DevIL-1.8.0.tar.gz"
    sha256 "0075973ee7dd89f0507873e2580ac78336452d29d34a07134b208f44e2feb709"

    # jpeg 9 compatibility
    # Upstream commit from 3 Jan 2017 "Fixed int to boolean conversion error
    # under Linux"
    patch do
      url "https://github.com/DentonW/DevIL/commit/41fcabbe.patch?full_index=1"
      sha256 "324dc09896164bef75bb82b37981cc30dfecf4f1c2386c695bb7e92a2bb8154d"
    end

    # jpeg 9 compatibility
    # Upstream commit from 7 Jan 2017 "Fixing boolean compilation errors under
    # Linux / MacOS, issue #48 at https://github.com/DentonW/DevIL/issues/48"
    patch do
      url "https://github.com/DentonW/DevIL/commit/4a2d7822.patch?full_index=1"
      sha256 "7e74a4366ef485beea1c4285f2b371b6bfa0e2513b83d4d45e4e120690c93f1d"
    end
  end

  bottle do
    cellar :any
    sha256 "1d95bffc40243d4489ebfe8335d4eea0691b66f2f0b2ee1a5dd699632346c692" => :sierra
    sha256 "64054158e523a5f2e575301454119b3a9fd159d2941e8349c6f7effdf229ed0e" => :el_capitan
    sha256 "906a89e5b5b593260a6bbd4cbab351adee051bde3dcaec7e61db62eacbcd74bd" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "jasper"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"

  def install
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

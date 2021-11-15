class Devil < Formula
  desc "Cross-platform image library"
  homepage "https://sourceforge.net/projects/openil/"
  license "LGPL-2.1-only"
  revision 2
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

    # allow compiling against jasper >= 2.0.17
    patch do
      url "https://github.com/DentonW/DevIL/commit/42a62648.patch?full_index=1"
      sha256 "b3a99c34cd7f9a5681f43dc0886fe360ba7d1df2dd1eddd7fcdcae7898f7a68e"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7006ca5332772d083b7b116398bbbd6beca5df0492b98579dffd1bea0aa36020"
    sha256 cellar: :any,                 arm64_big_sur:  "5091d86828c5b1c88ba853fdcf0fa90a8ff6b3ba0d682330ecb3740b91453d37"
    sha256 cellar: :any,                 monterey:       "3c430e39789f7e4212dbc8be7818f2f69b6ee4ff6f6558a0160a848d0625818c"
    sha256 cellar: :any,                 big_sur:        "620f8f3092f690123ed2365fec5c39a1258e0705e8b5df5de5120102e6fca007"
    sha256 cellar: :any,                 catalina:       "4ab10b6765d5417246c6a7cf2a6fef05969c7216fe353c0ee5a9b562afe03d3e"
    sha256 cellar: :any,                 mojave:         "3031f881197694ff89cbe658af6e15a4abe11d995cd280eb38e1c5b1ba622b82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd9ed2926be7a68693079bed2d54d506619b5d84b18f22281a0fb503c5dab7d5"
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
    (testpath/"test.cpp").write <<~EOS
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

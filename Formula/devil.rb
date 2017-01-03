class Devil < Formula
  desc "Cross-platform image library"
  homepage "https://sourceforge.net/projects/openil/"
  url "https://downloads.sourceforge.net/project/openil/DevIL/1.8.0/DevIL-1.8.0.tar.gz"
  sha256 "0075973ee7dd89f0507873e2580ac78336452d29d34a07134b208f44e2feb709"
  head "https://github.com/DentonW/DevIL.git"

  bottle do
    cellar :any
    sha256 "4d26759aad301828515cd26de8a58e712fa23bd746949306f1c88b1eb4b7af27" => :sierra
    sha256 "1953824a6ba55112277ba40ee9604c58b4c93d3b61950583323113fd64ed5ae3" => :el_capitan
    sha256 "bd23907c8dd2202835e8cfb5e03b879aa304a2bdf74481a3d148231b869ae230" => :yosemite
    sha256 "5d77a3dcfed8123738dbfa1d77ea6dd2459688b0acbc35a0fd5dfe4b2cf0fead" => :mavericks
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

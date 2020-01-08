class Ompl < Formula
  desc "Open Motion Planning Library consists of many motion planning algorithms"
  homepage "https://ompl.kavrakilab.org/"
  url "https://bitbucket.org/ompl/ompl/downloads/ompl-1.4.2-Source.tar.gz"
  sha256 "03d5a661061928ced63bb945055579061665634ef217559b1f47fef842e1fa85"

  bottle do
    rebuild 1
    sha256 "9402582e9dba3b47fb91bd36dec50086fd36effaf4cf5734c44c4d71362729eb" => :catalina
    sha256 "14033d9549ebd3086e84cd058ab2df19e90acfc6c1e3c1b4d62f4a6b8c8058d6" => :mojave
    sha256 "961b2a574fdf47d8fd0e74e9755bfb3009147807a316869fa2444d61f9b4123f" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "eigen"

  # fix for Boost 1.71
  patch do
    url "https://github.com/ompl/ompl/commit/962961fb.diff?full_index=1"
    sha256 "56adf06b5bdc12823c04e96e764618c48a912fd01422138f15cc578f2464177a"
  end

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <ompl/base/spaces/RealVectorBounds.h>
      #include <cassert>
      int main(int argc, char *argv[]) {
        ompl::base::RealVectorBounds bounds(3);
        bounds.setLow(0);
        bounds.setHigh(5);
        assert(bounds.getVolume() == 5 * 5 * 5);
      }
    EOS

    system ENV.cxx, "test.cpp", "-L#{lib}", "-lompl", "-o", "test"
    system "./test"
  end
end

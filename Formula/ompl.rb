class Ompl < Formula
  desc "Open Motion Planning Library consists of many motion planning algorithms"
  homepage "http://ompl.kavrakilab.org"
  url "https://bitbucket.org/ompl/ompl/downloads/ompl-1.3.1-Source.tar.gz"
  sha256 "44932fe3cf63a2dcf42a3094eadd1527e5798d804ebff4174d7816f2344fc914"

  bottle do
    sha256 "6656ef91728aa361fdbf787707ed481f32e2740d81431c8873f8679cff495658" => :high_sierra
    sha256 "c06833fa4fa812a720ed8865c74b4b44f17cf16c557be3cfaa6954b8b3ecdaee" => :sierra
    sha256 "2ba2e0b77227ae6bb41be0605a3a5e205418592475bd1c1134e38faaefb89b1b" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "eigen" => :optional
  depends_on "ode" => :optional

  needs :cxx11

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

    system ENV.cc, "test.cpp", "-L#{lib}", "-lompl", "-lstdc++", "-o", "test"
    system "./test"
  end
end

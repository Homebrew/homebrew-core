class Ompl < Formula
  desc "Open Motion Planning Library consists of many motion planning algorithms"
  homepage "https://ompl.kavrakilab.org/"
  url "https://bitbucket.org/ompl/ompl/downloads/ompl-1.4.1-Source.tar.gz"
  sha256 "409b968b4174df347eeb77945adb5d03c093480c50c20add958664ad2a8ab29b"

  bottle do
    rebuild 1
    sha256 "c637602fadf8d0c60f53ae052685bc968cfcd1da71573fc2de55fe44b3fc4629" => :mojave
    sha256 "8ff68e8b4aef7262577918ed7b2b832f7127d2206a9314a411a25e12b333d8c4" => :high_sierra
    sha256 "57302b37d93b99a173dca146b9ca5f20eb63a9686372b3dc39d5a014224bf32f" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "eigen"

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

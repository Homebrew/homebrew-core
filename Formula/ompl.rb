class Ompl < Formula
  desc "Open Motion Planning Library consists of many motion planning algorithms"
  homepage "https://ompl.kavrakilab.org/"
  url "https://bitbucket.org/ompl/ompl/downloads/ompl-1.4.0-Source.tar.gz"
  sha256 "da8c273a2ed946fbcd7b721649a4767fdc1433e257bdc9a3d6c689b81261cc4f"

  bottle do
    sha256 "2b2ee9ee9ffc1a953510e3a67356540752a45869d294df5a0d68d18298d1dcde" => :mojave
    sha256 "5d302fc5273c7ba471fd31f38df77571105346f6dd834d771e0c71ad78ac2250" => :high_sierra
    sha256 "d6b642e9a487b895465e9327a0435be421b8197ee86d95dd1637076b4698aa7c" => :sierra
    sha256 "3cdfb00f4f2a1f19a15764bb91b068c8087b472f0614f9d79a76800372213296" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "eigen"
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

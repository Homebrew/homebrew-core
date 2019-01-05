class Ompl < Formula
  desc "Open Motion Planning Library consists of many motion planning algorithms"
  homepage "https://ompl.kavrakilab.org/"
  url "https://bitbucket.org/ompl/ompl/downloads/ompl-1.4.1-Source.tar.gz"
  sha256 "409b968b4174df347eeb77945adb5d03c093480c50c20add958664ad2a8ab29b"

  bottle do
    sha256 "7c24a4217f117907a8a709c6c07712612357c45b184fe2e1af58316679cb6d4a" => :mojave
    sha256 "802ac697fd52664ed73225122a5cf9e1df38911df8d695c6fbf87d453bfae5a8" => :high_sierra
    sha256 "5d72b5722d23b3493118974ca35d93c9d694fa73474f6aba97a26a74f38bcd8d" => :sierra
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

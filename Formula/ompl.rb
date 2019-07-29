class Ompl < Formula
  desc "Open Motion Planning Library consists of many motion planning algorithms"
  homepage "https://ompl.kavrakilab.org/"
  url "https://bitbucket.org/ompl/ompl/downloads/ompl-1.4.2-Source.tar.gz"
  sha256 "03d5a661061928ced63bb945055579061665634ef217559b1f47fef842e1fa85"

  bottle do
    sha256 "265baf6e114b571afba3e29affcacda2bdd5b98f98be9cfddf9dd4966043b6d8" => :mojave
    sha256 "75ccf7aea2c76430746126f38c04f463638a924a62884e060a90bdc915285e75" => :high_sierra
    sha256 "68d8a29fabd7d3b9aaed23f9b9b2ab5d72eed79d1a96b6bc6978d914d84cf204" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "eigen"

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

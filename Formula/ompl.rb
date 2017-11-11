class Ompl < Formula
  desc "Open Motion Planning Library consists of many motion planning algorithms"
  homepage "http://ompl.kavrakilab.org"
  url "https://bitbucket.org/ompl/ompl/downloads/ompl-1.3.2-Source.tar.gz"
  sha256 "c33e04089f7513780f4e87b6507182d5224cd604b0a4f4546ebb9f4a124c8f49"

  bottle do
    sha256 "282c1373ec4b0e790acc7008c3d3d8f8b5da3d8f1aaa76d5e7d0adb04fbe1239" => :high_sierra
    sha256 "9d663d2cc9c32261dbc39fe28d3df6ee521ee4e20fc00c2d5828ca62c17fe616" => :sierra
    sha256 "87f29ccd62630540a449661ef177c4662d157e94ba9114d2302db32a1f1e0fe9" => :el_capitan
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

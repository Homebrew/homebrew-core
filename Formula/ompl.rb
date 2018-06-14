class Ompl < Formula
  desc "Open Motion Planning Library consists of many motion planning algorithms"
  homepage "https://ompl.kavrakilab.org/"
  url "https://bitbucket.org/ompl/ompl/downloads/ompl-1.3.3-Source.tar.gz"
  sha256 "687a7c6b7e3cec0279e86ade4e10d728b961349aa35f1a0bfc1a9e95ca3a07c9"

  bottle do
    sha256 "e82c4a508e787d00239b0fbf6753930eceac31e42e5135b6d1316a16aff88749" => :high_sierra
    sha256 "034e0e9a6a9aa264af6bcc5e07690238045ac37503f11a514c8d1c4c4b0f2030" => :sierra
    sha256 "22ee1e888d334c6da893670156aada0d57dbc5ea507f8f81c618c9e40bed5fd1" => :el_capitan
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

class Ompl < Formula
  desc "Open Motion Planning Library consists of many motion planning algorithms"
  homepage "https://ompl.kavrakilab.org/"
  url "https://bitbucket.org/ompl/ompl/downloads/ompl-1.4.0-Source.tar.gz"
  sha256 "da8c273a2ed946fbcd7b721649a4767fdc1433e257bdc9a3d6c689b81261cc4f"

  bottle do
    sha256 "e82c4a508e787d00239b0fbf6753930eceac31e42e5135b6d1316a16aff88749" => :high_sierra
    sha256 "034e0e9a6a9aa264af6bcc5e07690238045ac37503f11a514c8d1c4c4b0f2030" => :sierra
    sha256 "22ee1e888d334c6da893670156aada0d57dbc5ea507f8f81c618c9e40bed5fd1" => :el_capitan
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

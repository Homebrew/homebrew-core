class Libheinz < Formula
  desc "C++ base library of Heinz Maier-Leibnitz Zentrum"
  homepage "https://jugit.fz-juelich.de/mlz/lib/heinz"
  url "https://jugit.fz-juelich.de/mlz/lib/heinz/-/archive/v4.1.0/heinz-v4.1.0.tar.bz2"
  sha256 "86daa9a501270bc0d1b8dfa1e83ed2dc1b598b0bd129cc73abca70018138a3ff"
  license "0BSD"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "92053ba8b668210ee819953fd0e47dd4d41ab8b8315920f9b9d4939bca8cbd01"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <heinz/Vectors3D.h>
      #include <iostream>

      int main() {
        R3 vector(1.0, 2.0, 3.0);
        if (vector.x() == 1.0 && vector.y() == 2.0 && vector.z() == 3.0) {
          std::cout << "Success" << std::endl;
          return 0;
        }
        return 1;
      }
    CPP

    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}", "-o", "test"
    system "./test"
  end
end

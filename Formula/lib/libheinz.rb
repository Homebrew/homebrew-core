class Libheinz < Formula
  desc "C++ base library of Heinz Maier-Leibnitz Zentrum"
  homepage "https://jugit.fz-juelich.de/mlz/libheinz"
  url "https://jugit.fz-juelich.de/mlz/libheinz/-/archive/v4.1.0/libheinz-v4.1.0.tar.bz2"
  sha256 "c22ae3d26e6fa34bce14424ad335cf4189df15a0419650e60b4138a914245e4f"
  license "0BSD"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a4769b4fef0ada5e2d512dcf00da31f24d66c125531e36065acf668f1b6e88fc"
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

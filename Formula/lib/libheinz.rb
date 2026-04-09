class Libheinz < Formula
  desc "C++ base library of Heinz Maier-Leibnitz Zentrum"
  homepage "https://jugit.fz-juelich.de/mlz/libheinz"
  url "https://jugit.fz-juelich.de/mlz/libheinz/-/archive/v3.0.0/libheinz-v3.0.0.tar.bz2"
  sha256 "faf949e2cd336a7db8da3d16eb86757c9106d4fa67abd5bfafd58a9a71bfe31f"
  license "0BSD"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "67948152c574c30d8166f03ad0c64a713f59e862bce1ba3d3df1b0729b5b2144"
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

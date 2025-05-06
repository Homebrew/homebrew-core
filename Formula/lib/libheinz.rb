class Libheinz < Formula
  desc "C++ base library of Heinz Maier-Leibnitz Zentrum"
  homepage "https://jugit.fz-juelich.de/mlz/libheinz"
  url "https://jugit.fz-juelich.de/mlz/libheinz/-/archive/v2.0.1/libheinz-v2.0.1.tar.bz2"
  sha256 "f5e84a597d808cb694d9051aea2d5c2f4f7a487f7b107e22e17096c258331fea"
  license "0BSD"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5ef6b1109b5b5299b0666d217bb0300e0bf07000f6b2d63c7f871af8a7ecef12"
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

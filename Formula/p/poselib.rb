class Poselib < Formula
  desc "Minimal solvers for calibrated camera pose estimation"
  homepage "https://github.com/PoseLib/PoseLib/"
  url "https://github.com/PoseLib/PoseLib/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "caa0c1c9b882f6e36b5ced6f781406ed97d4c1f0f61aa31345ebe54633d67c16"
  license "BSD-3-Clause"

  depends_on "cmake" => :build
  depends_on "eigen"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "cmake", "-S", ".", "-B", "static", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
    system "cmake", "--build", "static"
    lib.install Dir["static/PoseLib/*.a"]
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "Poselib/poselib.h"
      #include <iostream>

      int main(int argc, char *argv[])
      {
        std::vector<Eigen::Vector3d> X = {
            {1.0, 2.0, 3.0},
            {4.0, 5.0, 6.0},
            {7.0, 8.0, 9.0}
        };
        std::vector<Eigen::Vector3d> x = {
            {0.5, 0.5, 0.707},
            {0.3, 0.4, 0.866},
            {0.2, 0.1, 0.979}
        };
        std::vector<Eigen::Vector3d> p = {
            {0.0, 0.0, 0.0},
            {0.1, 0.0, 0.0},
            {0.0, 0.1, 0.0}
        };
        std::vector<poselib::CameraPose> output;

        int num_solutions = poselib::gp3p(p, x, X, &output);
        std::cout << num_solutions << std::endl;

        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17",
                    "-I#{Formula["eigen"].opt_include}/eigen3",
                    "-L#{lib}", "-lposelib", "-o", "test"

    assert_equal "4\n", shell_output("./test")
  end
end

class Poselib < Formula
  desc "Minimal solvers for calibrated camera pose estimation"
  homepage "https://github.com/PoseLib/PoseLib/"
  url "https://github.com/PoseLib/PoseLib/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "caa0c1c9b882f6e36b5ced6f781406ed97d4c1f0f61aa31345ebe54633d67c16"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "62ba1d9d73288e53a7fa31462a0aeef5eb5d32305d77c5207bf626d0c8d52711"
    sha256 cellar: :any,                 arm64_sonoma:  "0c58c6ca1d520956f808e52273fdd32ea132021906e629325272272dacb90c7b"
    sha256 cellar: :any,                 arm64_ventura: "7b6e8c4abb3b2e00c8dfa0aa600599c9d930724e09d1dcf45339c903121fa8f1"
    sha256 cellar: :any,                 sonoma:        "e520e1731c729e1ee2dc91a3d6e3d5773bc6f5414098b6b0d61aa7984a3d7467"
    sha256 cellar: :any,                 ventura:       "3e3d39c0763a6efacdc2f9154851ee80174ac64ad3aa0518fa9e35871e42cb53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39566056afc9dc3a3f6aa15adbe8fa603b1f2650a3903c76f94c053e8ec8f0bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "598ee718057f572aebb473a515f4201391808f59563811eaa8809a5dcc7bbacf"
  end

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
      #include "PoseLib/poselib.h"
      #include <iostream>

      int main(int argc, char *argv[])
      {
        Eigen::Vector2d imgA(315, 217);
        Eigen::Vector2d imgB(361, 295);
        Eigen::Vector2d imgC(392, 660);
        Eigen::Vector2d imgD(146, 220);

        Eigen::Vector2d pp(280, 420);

        std::vector<Eigen::Vector2d> points2D = { imgA - pp, imgB - pp, imgC - pp, imgD - pp};

        Eigen::Vector3d a(-20.96, 3.54, 13.86);
        Eigen::Vector3d b(-20.96, 3.57, 13.24);
        Eigen::Vector3d c(-20.95, 2.01, 13.25);
        Eigen::Vector3d d(-21.66, 3.74, 13.86);

        std::vector<Eigen::Vector3d> points3D = { a, b, c, d };

        std::vector<poselib::CameraPose> output;
        std::vector<double> output_fx, output_fy;

        int result = poselib::p4pf(points2D, points3D,  &output, &output_fx, &output_fy, true);

        for(int k = 0; k < output.size(); ++k) {
            poselib::CameraPose pose = output[k];
            double fx = output_fx[k];
            double fy = output_fy[k];

            std::cout << pose.R() << std::endl;
        }

        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17",
                    "-I#{Formula["eigen"].opt_include}/eigen3",
                    "-L#{lib}", "-lPoseLib", "-o", "test"

    expected_output = <<~EOS
      \s 0.934064 -0.0235118  -0.356331
      \s-0.165184   -0.91311  -0.372753
      \s-0.316605   0.407035  -0.856787
    EOS
    assert_equal expected_output, shell_output("./test")
  end
end

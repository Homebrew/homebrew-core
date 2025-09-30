class Poselib < Formula
  desc "Minimal solvers for calibrated camera pose estimation"
  homepage "https://github.com/PoseLib/PoseLib/"
  url "https://github.com/PoseLib/PoseLib/archive/refs/tags/v2.0.5.tar.gz"
  sha256 "a9493e6725c58e6ae541fe416c0a6179185a60006880ff3ddf32737a43695668"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dd83a55d57f61c2c99e5711cf0bd80e792d686a82f3e326945eaf42675340589"
    sha256 cellar: :any,                 arm64_sequoia: "72e32c33fce8115a8e061c70f2d96f67daa47d5fd44ad211ab367ac472d85540"
    sha256 cellar: :any,                 arm64_sonoma:  "31a44969e52bc29df45aa648e264be5689b0e4c129c6b77a95ef7b205b90d719"
    sha256 cellar: :any,                 arm64_ventura: "0af8973a43aa261e9becdf5c1595e1682e8b6d153ec754e66df76056db6efdf8"
    sha256 cellar: :any,                 sonoma:        "7dedd4a54068190cb6a94a1f3974e26ecdaa860f49c3a98d4b2c17464eece401"
    sha256 cellar: :any,                 ventura:       "693a649c3146d200f474af3905394f4b0287a0b0b00b715462ad3ad5715f8db9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4dbeb31076c8ad21201c7d6c2b9c4044663e5dc4a07ffec881a855fcfd1256e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "590b3174a491f0e1349a974c3b73f0fddbe3a66e887da4e882854ab65c843f61"
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

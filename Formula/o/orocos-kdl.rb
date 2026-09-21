class OrocosKdl < Formula
  desc "Orocos Kinematics and Dynamics C++ library"
  homepage "https://orocos.org/"
  url "https://github.com/orocos/orocos_kinematics_dynamics/archive/refs/tags/1.5.4.tar.gz"
  sha256 "b47c75b03d5980a8b3a5382ab1176ae552f2f5418ad42b0e530a4178e3e1c301"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4cc482ded62e2126f68ce6f520aed5addb36d93ffc88691aed96b2a5d61268ce"
    sha256 cellar: :any, arm64_tahoe:       "a22662680404401c27ba5697b191b8386cc419546cdb8fd168c1b13715b04096"
    sha256 cellar: :any, arm64_sequoia:     "c51a6f4e6be872711b72a6fc6b7eb7cccb0e770c1efbb4f607ece485cbf1b03b"
    sha256 cellar: :any, arm64_sonoma:      "d1a3490e975f2a02dda0f39a97c962bf313b11959476a61581fcf64381630b63"
    sha256 cellar: :any, arm64_linux:       "3068dcfd1b9d2ba33dcabfa0b014cec0d24e43343d740b6ddc38b098019c5f91"
    sha256 cellar: :any, x86_64_linux:      "b61040599cad3d979cee7d48f7b9888e2d83ddd5ab22ca221b5a4ce90e873e18"
  end

  depends_on "cmake" => :build
  depends_on "eigen"

  def install
    system "cmake", "-S", "orocos_kdl", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=14",
                    "-DEIGEN3_INCLUDE_DIR=#{formula_opt_include("eigen")}/eigen3",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <kdl/frames.hpp>
      int main()
      {
        using namespace KDL;
        Vector v1(1.,0.,1.);
        Vector v2(1.,0.,1.);
        assert(v1==v2);
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++14", "-I#{include}", "-L#{lib}", "-lorocos-kdl",
                    "-o", "test"
    system "./test"
  end
end

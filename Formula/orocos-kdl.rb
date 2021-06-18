class OrocosKdl < Formula
  desc "Orocos Kinematics and Dynamics C++ library"
  homepage "https://orocos.org/"
  url "https://github.com/orocos/orocos_kinematics_dynamics/archive/v1.5.0.tar.gz"
  sha256 "6d4b04c465f0974286fbb419c40e3aca145f616571f2462e2696b830288234a9"
  license "LGPL-2.1"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c576e606256440c65e04cc0fd2aed93362c357ad25a46fc0f72aac022b0eec44"
    sha256 cellar: :any, big_sur:       "615f504ff88df9e2e465dcbef63eb273499bc46227e3d68d23e074d91cc1ea51"
    sha256 cellar: :any, catalina:      "4d1e1513aab353a9007de15aa819123cbb6593a9878e34bb951daea6ab8193c7"
    sha256 cellar: :any, mojave:        "bce9b01c40d1c6f2ecf4362e98466ced1fffc587d9ca8e08af2da301a8852431"
  end

  depends_on "cmake" => :build
  depends_on "eigen"

  def install
    cd "orocos_kdl" do
      system "cmake", ".", "-DEIGEN3_INCLUDE_DIR=#{Formula["eigen"].opt_include}/eigen3",
                           *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <kdl/frames.hpp>
      int main()
      {
        using namespace KDL;
        Vector v1(1.,0.,1.);
        Vector v2(1.,0.,1.);
        assert(v1==v2);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lorocos-kdl",
                    "-o", "test"
    system "./test"
  end
end

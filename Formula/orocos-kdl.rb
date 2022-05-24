class OrocosKdl < Formula
  desc "Orocos Kinematics and Dynamics C++ library"
  homepage "https://orocos.org/"
  url "https://github.com/orocos/orocos_kinematics_dynamics/archive/v1.5.1.tar.gz"
  sha256 "5acb90acd82b10971717aca6c17874390762ecdaa3a8e4db04984ea1d4a2af9b"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d500d33947bf10c203f853e3476cd4c2f86eb576c24cbd6b36e129a27a92846b"
    sha256 cellar: :any,                 arm64_big_sur:  "70f546d7391dea4d7005d93f3720cde06f14e53b3cc7c514d67376ea05ac6493"
    sha256 cellar: :any,                 monterey:       "97af713602639e5fd50b3027a97d8c6d7aa7261a90fe474ac35325b48032319e"
    sha256 cellar: :any,                 big_sur:        "1c7f7a1fc384bd107acd0d3b8d302beed12c89198617f19b2c74d89e437e3ee8"
    sha256 cellar: :any,                 catalina:       "4318687278abffc43d727c33539957387dbbab41f7ec9c08a4f5ff7a6061abd1"
    sha256 cellar: :any,                 mojave:         "be089171fe396309561089d802e13ec101e56e91a5d2141207d588c1f703f52b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76ca5a86d809b86783da8111f4d3aa54f0f3cf6e2eb09dc499e0b5de4e6257f9"
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

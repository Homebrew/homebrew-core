class Clhep < Formula
  desc "Class Library for High Energy Physics"
  homepage "https://proj-clhep.web.cern.ch/proj-clhep/"
  url "https://proj-clhep.web.cern.ch/proj-clhep/dist1/clhep-2.4.5.2.tgz"
  sha256 "3a87de7c0c41a877212ee3d0d2ac5afe315299ae278ce7858b2ec7249ef2d911"
  license "GPL-3.0-only"
  head "https://gitlab.cern.ch/CLHEP/CLHEP.git", branch: "develop"

  livecheck do
    url :homepage
    regex(%r{atest release.*?<b>v?(\d+(?:\.\d+)+)</b>}im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b2255c067eaebc72b6a193f72dd6a5c6d4c91a874fb04f5a42bef4240024e65b"
    sha256 cellar: :any,                 arm64_big_sur:  "2c31ff847d0f1236c461f5742f2a29f22335c851ed65df3d559c78842795289a"
    sha256 cellar: :any,                 monterey:       "3af86a08db892d9516d51d4f67c0cc0ecb4deb048cf99b3ac03beac99f8adf3e"
    sha256 cellar: :any,                 big_sur:        "e0768b1406e55f56f9eb8419c1067419439e87327cceef8cfd7c903db6542da6"
    sha256 cellar: :any,                 catalina:       "82d2152745abc5b61be30c968691f606232e526b2d3a63e3c2c5891e2611d2c9"
    sha256 cellar: :any,                 mojave:         "4030d211eba12da6127b28db8fe2a35dab9107a8dce49bddff58aada997dbeb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "548f3418aaaa382af761e4eda5d888cead02febf767d01964070b52bd34a6da2"
  end

  depends_on "cmake" => :build

  def install
    (buildpath/"CLHEP").install buildpath.children if build.head?
    system "cmake", "-S", "CLHEP", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <Vector/ThreeVector.h>

      int main() {
        CLHEP::Hep3Vector aVec(1, 2, 3);
        std::cout << "r: " << aVec.mag();
        std::cout << " phi: " << aVec.phi();
        std::cout << " cos(theta): " << aVec.cosTheta() << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "-L#{lib}", "-lCLHEP", "-I#{include}/CLHEP",
           testpath/"test.cpp", "-o", "test"
    assert_equal "r: 3.74166 phi: 1.10715 cos(theta): 0.801784",
                 shell_output("./test").chomp
  end
end

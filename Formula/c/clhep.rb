class Clhep < Formula
  desc "Class Library for High Energy Physics"
  homepage "https://proj-clhep.web.cern.ch/proj-clhep/"
  url "https://proj-clhep.web.cern.ch/proj-clhep/dist1/clhep-2.4.7.1.tgz"
  sha256 "1c8304a7772ac6b99195f1300378c6e3ddf4ad07c85d64a04505652abb8a55f9"
  license "GPL-3.0-only"
  head "https://gitlab.cern.ch/CLHEP/CLHEP.git", branch: "develop"

  livecheck do
    url :homepage
    regex(%r{atest release.*?<b>v?(\d+(?:\.\d+)+)</b>}im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0e69dfb6c076d3b6c87ff2fa67018eabf9e2d33ecfcc60505e614958a8baa748"
    sha256 cellar: :any,                 arm64_ventura:  "7394489e65b6b3b4eb7af0878e70fa4d77a93ff343093594cb591022cf193239"
    sha256 cellar: :any,                 arm64_monterey: "f46bbb06f3914fe69fa4e59c1eba50702765c0143f3f0b5fbc974ca1e53fae20"
    sha256 cellar: :any,                 sonoma:         "cbcacb7078f9300077e8f44c0dc740e9fd61e3b4605459f46c5fba0839896375"
    sha256 cellar: :any,                 ventura:        "970da332b593e58aa660a15ace387d67cc281dcf9acaf06282902bb3086e13fc"
    sha256 cellar: :any,                 monterey:       "d2fffe1750260f11c55af6d2c5d8aac74721ef309f0d8d475e38f48200489619"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb0cb80110d08ad05f90f16b7186651d15288c3ab770121ae1edfa45ce9b88c9"
  end

  depends_on "cmake" => :build

  def install
    (buildpath/"CLHEP").install buildpath.children if build.head?
    system "cmake", "-S", "CLHEP", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
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

class Clhep < Formula
  desc "Class Library for High Energy Physics"
  homepage "https://proj-clhep.web.cern.ch/proj-clhep/"
  url "https://proj-clhep.web.cern.ch/proj-clhep/dist1/clhep-2.4.6.3.tgz"
  sha256 "fcd007f11b10ba4af28d027222b63148d0eb44ff7a082eee353bdf921f9c684a"
  license "GPL-3.0-only"
  head "https://gitlab.cern.ch/CLHEP/CLHEP.git", branch: "develop"

  livecheck do
    url :homepage
    regex(%r{atest release.*?<b>v?(\d+(?:\.\d+)+)</b>}im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d4e42f0b132dc01ad5a585d21245ab27b3b5786af8eb7ea2bcc1c3fd3aa5b26e"
    sha256 cellar: :any,                 arm64_monterey: "6aa633b75a154f136a5a7b20295a98c4b88fdb7cdf133d2f5b61ed4d55254cf0"
    sha256 cellar: :any,                 arm64_big_sur:  "4475b22a0678addf7be68ea7437b27ba97600841517b8d5bcf73e7534bfea56c"
    sha256 cellar: :any,                 ventura:        "82f8d74a00f92c86b7c1695d67b6010ad63297582fd28aa0c971cb8919545707"
    sha256 cellar: :any,                 monterey:       "78116b67ee5390a1abee1f27d07c755448b1d44ad006f320931ab97c023e2e15"
    sha256 cellar: :any,                 big_sur:        "40bf5b2daa80692fdfe1360d0b326ba8d016f73b228909fab30b32aa5d7604e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "342c4de82329f7e1d50eac4b99e1549fedef980c3450359a7fdcbd029c70d8c0"
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

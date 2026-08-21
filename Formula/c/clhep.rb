class Clhep < Formula
  desc "Class Library for High Energy Physics"
  homepage "https://proj-clhep.web.cern.ch/proj-clhep/"
  url "https://gitlab.cern.ch/CLHEP/CLHEP/-/archive/CLHEP_2_4_7_2/CLHEP-CLHEP_2_4_7_2.tar.gz"
  sha256 "c40c239fa2c5810b60f4e9ddd6a8cc2ce81b962aa170994748cd2a2b5ac87f84"
  license "GPL-3.0-only"
  head "https://gitlab.cern.ch/CLHEP/CLHEP.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cf183afa1e10e5cf5a22b0c8e56acd6dc3ee832cb38abc08c4f65ccc6d61be32"
    sha256 cellar: :any,                 arm64_sequoia: "4d6bda58d173b42913d91dded7b7ad721b358260a8382934fafdb464cafbc786"
    sha256 cellar: :any,                 arm64_sonoma:  "3645180de75c594150af1353381b28d732b2d75944a6110d67d4d9ae408de220"
    sha256 cellar: :any,                 sonoma:        "820fbd323a9a40b44053ae03d2c0598df6d8d5b58fcefe07ff4dd1fdb4704d52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf31c521a79cc3bff39ab122f7ae26bbea6b4e5d5304df4420378a90ad7388ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08488a8b36a245edbb41e6f91f84e8a264d6f4cf35fc1e0b89041bd37f3c44fd"
  end

  depends_on "cmake" => :build

  def install
    # Build directory is not allowed inside source folder
    (buildpath/"CLHEP").install buildpath.children
    system "cmake", "-S", "CLHEP", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <Vector/ThreeVector.h>

      int main() {
        CLHEP::Hep3Vector aVec(1, 2, 3);
        std::cout << "r: " << aVec.mag();
        std::cout << " phi: " << aVec.phi();
        std::cout << " cos(theta): " << aVec.cosTheta() << std::endl;
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++11", "-L#{lib}", "-lCLHEP", "-I#{include}/CLHEP",
           testpath/"test.cpp", "-o", "test"
    assert_equal "r: 3.74166 phi: 1.10715 cos(theta): 0.801784",
                 shell_output("./test").chomp
  end
end

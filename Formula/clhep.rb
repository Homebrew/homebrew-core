class Clhep < Formula
  desc "Class Library for High Energy Physics"
  homepage "https://proj-clhep.web.cern.ch/proj-clhep/"
  url "https://proj-clhep.web.cern.ch/proj-clhep/dist1/clhep-2.4.6.2.tgz"
  sha256 "aded73e49bac85a5b4e86f64a0ee3d6f3cfe5551b0f7731c78b6d8f9dac6e8dc"
  license "GPL-3.0-only"
  head "https://gitlab.cern.ch/CLHEP/CLHEP.git", branch: "develop"

  livecheck do
    url :homepage
    regex(%r{atest release.*?<b>v?(\d+(?:\.\d+)+)</b>}im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a16ce7e7c2e2622686963f8549bdf088cfe57bb6078f8eb030e6e02858f53ac5"
    sha256 cellar: :any,                 arm64_monterey: "c22a80ec97e83fd66173d935d399a601ea0a3d5d136ca76334608335a6723b7b"
    sha256 cellar: :any,                 arm64_big_sur:  "391da90b1986c6e4e651962894c6a773996a91d9975d4dd968e0012e0465738a"
    sha256 cellar: :any,                 ventura:        "ed395b9e469a2aad0e54f123077512123fe4fe7ef6a0605abd403919bfa5d558"
    sha256 cellar: :any,                 monterey:       "88dfbe12e1f1207848ed03d61008ee5a46eba9a0032d89e42c24f9789dc4df85"
    sha256 cellar: :any,                 big_sur:        "999b17307c0eceb9aa90c7b292530f841a7b17664b1e0c0898269321762c3e78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "265d43475b57fa78dd9ffaf6c43341b677dcd8bdd63f150306c694c13414afca"
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

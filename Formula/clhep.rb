class Clhep < Formula
  desc "Class Library for High Energy Physics"
  homepage "https://proj-clhep.web.cern.ch/proj-clhep/"
  url "https://proj-clhep.web.cern.ch/proj-clhep/dist1/clhep-2.4.6.4.tgz"
  sha256 "49c89330f1903ef707d3c5d79c16a7c5a6f2c90fc290e2034ee3834809489e57"
  license "GPL-3.0-only"
  head "https://gitlab.cern.ch/CLHEP/CLHEP.git", branch: "develop"

  livecheck do
    url :homepage
    regex(%r{atest release.*?<b>v?(\d+(?:\.\d+)+)</b>}im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "eb16b299e8546ab10918bd6b5d5bc24ad1b565a52b00587255a0336e1393194c"
    sha256 cellar: :any,                 arm64_monterey: "5b8a263dc48817da826dd69e5bc330cad3e7fc65c7d0a15846b3a640a6fd663d"
    sha256 cellar: :any,                 arm64_big_sur:  "9894adeb07e7fdc946ffa831b3cd1951eaff2149618b6e2628ef9969efdbc158"
    sha256 cellar: :any,                 ventura:        "99657ad3daa7d6e0b23e8f183229db6294db760533fbbbcdd02e1bf547ae26de"
    sha256 cellar: :any,                 monterey:       "92fac62085394f2fd084c6ee65c853b11efb25c06d6b54e27c2dbd0cf8931610"
    sha256 cellar: :any,                 big_sur:        "b4a2af8b3f70c6e35664bc7948d467b3f84a445d9d2f9817bc6860e7d16a07a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c76647da7e63c71460a1d99967dcfaec885160a22a04b441f785adf0b6062090"
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

class Clhep < Formula
  desc "Class Library for High Energy Physics"
  homepage "https://proj-clhep.web.cern.ch/proj-clhep/"
  url "https://proj-clhep.web.cern.ch/proj-clhep/dist1/clhep-2.4.5.4.tgz"
  sha256 "983fb4ea1fe423217fe9debc709569495a62a3b4540eb790d557c5a34dffbbb6"
  license "GPL-3.0-only"
  head "https://gitlab.cern.ch/CLHEP/CLHEP.git", branch: "develop"

  livecheck do
    url :homepage
    regex(%r{atest release.*?<b>v?(\d+(?:\.\d+)+)</b>}im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6cae06785c1274a80e3a67ee01784a920b200c97a46a1f12cc981d216e5e2259"
    sha256 cellar: :any,                 arm64_big_sur:  "928f2d70813ed53d112ff37a70a70ebf85d865902c57a176a8feb9b442c88590"
    sha256 cellar: :any,                 monterey:       "527987f8be76209050ace31c189f25fc6d7485ab93bdd6e7b17d21a615fdea80"
    sha256 cellar: :any,                 big_sur:        "98eeb5b83cb8d59d92ca1ca2e9cb845f4da6c60066148455477d7e2dfb3ebbc3"
    sha256 cellar: :any,                 catalina:       "020d3f58a54b878bb97d6e63caebc6730026d92db70340f0d4b57b65130be3b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb033d846c14583302e1975e38af849da27b8bd5a702719c356a88d9dcd4d1b2"
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

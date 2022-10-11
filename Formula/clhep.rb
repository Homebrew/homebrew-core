class Clhep < Formula
  desc "Class Library for High Energy Physics"
  homepage "https://proj-clhep.web.cern.ch/proj-clhep/"
  url "https://proj-clhep.web.cern.ch/proj-clhep/dist1/clhep-2.4.6.0.tgz"
  sha256 "e8d16debb84ced28e40e9ae84789cf5a0adad45f9213fbac3ce7583e06caa7b1"
  license "GPL-3.0-only"
  head "https://gitlab.cern.ch/CLHEP/CLHEP.git", branch: "develop"

  livecheck do
    url :homepage
    regex(%r{atest release.*?<b>v?(\d+(?:\.\d+)+)</b>}im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4fad1c91fda67a2dab603eb7ff52c353de429cc3be85e6316527681b34dfe914"
    sha256 cellar: :any,                 arm64_big_sur:  "2761bda7befffc623ddd37bfca75eaf4786b0a60e405570a5a95cf6b1aa2e874"
    sha256 cellar: :any,                 monterey:       "665bee2e8a1f25b7b378080f166d9a48744eb0847a81b5b6261ab28f84ce6611"
    sha256 cellar: :any,                 big_sur:        "d58e6f9147a5c7914afe364d0c065994befd18cf8ac07c1757ecfcf279401289"
    sha256 cellar: :any,                 catalina:       "8b8238885e182e0cb568a4059efdcd88efaced1907361fd0988b88b1a722a296"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e7b7f4389dbfae1ab43c282f4aa26ae39f3ba468e0be7b11139ed26997ae88f"
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

class Clhep < Formula
  desc "Class Library for High Energy Physics"
  homepage "https://proj-clhep.web.cern.ch/proj-clhep/"
  url "https://proj-clhep.web.cern.ch/proj-clhep/dist1/clhep-2.4.5.3.tgz"
  sha256 "45f63eeb097f02fe67b86a7dadbf10d409b401c28a1a3e172db36252c3097c13"
  license "GPL-3.0-only"
  head "https://gitlab.cern.ch/CLHEP/CLHEP.git", branch: "develop"

  livecheck do
    url :homepage
    regex(%r{atest release.*?<b>v?(\d+(?:\.\d+)+)</b>}im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "03db9b09c163489432f661f8fb0e3e306384cd2502b9b2f6f1529b2f23a16b8d"
    sha256 cellar: :any,                 arm64_big_sur:  "ec5cbe5f9cb70028bc2499eb251acf57f4d1f3b13636e10d7439ca41f5d1a1d2"
    sha256 cellar: :any,                 monterey:       "06cada1be4de446ebb178fac243b30f5ef213f564b9675008d883e635141685a"
    sha256 cellar: :any,                 big_sur:        "926d2ddc3956249db453f781bd5a7ba2c7c3d8c0ed7da92cbc469ebeff894b64"
    sha256 cellar: :any,                 catalina:       "c4f7aab53df59e4356288cf913eda6b2a32ae1bd44cd8fe41ec503aed9e8a02c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be930e4d03f1780be1587bf5aa34e3e5f0041bd2245c20c593bb5f4d23a3cd86"
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

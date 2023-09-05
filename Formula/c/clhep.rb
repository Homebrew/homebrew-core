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
    sha256 cellar: :any,                 arm64_ventura:  "7b67d5f2126c654cc71cce550503c9ece99a096a282ee6d4c72ba1b9728a7719"
    sha256 cellar: :any,                 arm64_monterey: "8cb9c70b5a6e2c381aeb3b90771a067b3a1c1ab4b90bebd231c83ab41960042e"
    sha256 cellar: :any,                 arm64_big_sur:  "fd58699820df87c48947705841efbe39f3a37810b3c666490246b61b3170ecb2"
    sha256 cellar: :any,                 ventura:        "e21bf078cd675c90ff8a54116dc0e9b2102e833eb903c9aef94c840db270167c"
    sha256 cellar: :any,                 monterey:       "03503a7558e25c9544a7857d7c7e8bbb1a319dccda7e6aba044572a40d2ceb05"
    sha256 cellar: :any,                 big_sur:        "1ba0050c52c6c47ce4120bcadb002afa7c4b19d1c263ad4125dd6218b0c8431c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd7aae44f9650430c7be0bcdd8ee71bf1044aa48a15ee4186353913e888f1fdc"
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

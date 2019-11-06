class Clhep < Formula
  desc "Class Library for High Energy Physics"
  homepage "https://proj-clhep.web.cern.ch/proj-clhep/"
  url "https://proj-clhep.web.cern.ch/proj-clhep/dist1/clhep-2.4.1.2.tgz"
  sha256 "ff96e7282254164380460bc8cf2dff2b58944084eadcd872b5661eb5a33fa4b8"

  bottle do
    cellar :any
    sha256 "116324dfc55263b65af4a0cd44e1d701ef67a5a285ce2ed2ad68b7bb19c8485b" => :catalina
    sha256 "b432a92dd9070812caa48707ed9068257b8a0162c81f8a2a3aaaf04285b75757" => :mojave
    sha256 "b9c5dded0bd84d70329d4c974018fd74d7b7b01363de2e1fd22d8500b0c51c40" => :high_sierra
    sha256 "7962be3355266b1c103eb87b5b46e649d4b6ca4b8925bd41f03f52a4d2abc19e" => :sierra
  end

  head do
    url "https://gitlab.cern.ch/CLHEP/CLHEP.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "cmake" => :build

  def install
    mv (buildpath/"CLHEP").children, buildpath if build.stable?
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
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
    system ENV.cxx, "-L#{lib}", "-lCLHEP", "-I#{include}/CLHEP",
           testpath/"test.cpp", "-o", "test"
    assert_equal "r: 3.74166 phi: 1.10715 cos(theta): 0.801784",
                 shell_output("./test").chomp
  end
end

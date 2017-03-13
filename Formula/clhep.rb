class Clhep < Formula
  desc "Class Library for High Energy Physics"
  homepage "https://proj-clhep.web.cern.ch/proj-clhep/"
  url "http://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/clhep-2.3.4.3.tgz"
  sha256 "1019479265f956bd660c11cb439e1443d4fd1655e8d51accf8b1e703e4262dff"

  bottle do
    cellar :any
    sha256 "6e0e6197e025d371b9a8ed4c71a1bd117dc087116edbf34528e0592518ee641a" => :sierra
    sha256 "ca3c67cfa4ed9cace3f0868d82322cabd3d4bee86b448c2942efab0a545ba46f" => :el_capitan
    sha256 "c02e259a9a446d0578fe82ae3847a9d0050c6c3b032d98b95d6ce4f348361777" => :yosemite
    sha256 "a9467330e9bd3b40011cc647cc7702c68f2665794f4ae62941eb70f8cccaebcb" => :mavericks
  end

  head do
    url "https://gitlab.cern.ch/CLHEP/CLHEP.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "cmake" => :build

  def install
    # CLHEP is super fussy and doesn't allow source tree builds
    dir = Dir.mktmpdir
    cd dir do
      args = std_cmake_args
      if build.stable?
        args << buildpath/"CLHEP"
      else
        args << buildpath
      end
      system "cmake", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
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

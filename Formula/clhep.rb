class Clhep < Formula
  desc "Class Library for High Energy Physics"
  homepage "https://proj-clhep.web.cern.ch/proj-clhep/"
  url "https://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/clhep-2.3.3.1.tgz"
  sha256 "cd74bfae4773620dd0c7cc9c1696a08386931d7e47a3906aa632cc5cb44ed6bd"

  bottle do
    cellar :any
    sha256 "ca3c67cfa4ed9cace3f0868d82322cabd3d4bee86b448c2942efab0a545ba46f" => :el_capitan
    sha256 "c02e259a9a446d0578fe82ae3847a9d0050c6c3b032d98b95d6ce4f348361777" => :yosemite
    sha256 "a9467330e9bd3b40011cc647cc7702c68f2665794f4ae62941eb70f8cccaebcb" => :mavericks
  end

  head do
    url "http://git.cern.ch/pub/CLHEP", :using => :git

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

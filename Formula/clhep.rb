class Clhep < Formula
  desc "Class Library for High Energy Physics"
  homepage "https://proj-clhep.web.cern.ch/proj-clhep/"
  url "https://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/clhep-2.3.4.4.tgz"
  sha256 "e54de15ffa5108a1913c4910845436345c89ddb83480cd03277a795fafabfb9d"

  bottle do
    cellar :any_skip_relocation
    sha256 "436a617b5e6356f083fb091ddd820b4d663eca38ebb4c47045002c1e8ba07067" => :sierra
    sha256 "ca2d2e28a8d1c21df312fc407341df04387d3b085dae0c80493f2ac5f88f3bc9" => :el_capitan
    sha256 "c2236e8c8561b24177c9383e0d3455e0f6d80c2c948e559d20165c570fca9715" => :yosemite
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

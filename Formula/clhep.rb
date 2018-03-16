class Clhep < Formula
  desc "Class Library for High Energy Physics"
  homepage "https://proj-clhep.web.cern.ch/proj-clhep/"
  url "https://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/clhep-2.4.0.4.tgz"
  sha256 "eb013841c57990befa1e977a11a552ab8328733c1c3b6cecfde86da40dc22113"

  bottle do
    cellar :any
    sha256 "e186a532b82e061c12b548ec6235fc50653e794fe1faad269bdf46ab3842087f" => :high_sierra
    sha256 "1ab8f484f1db7fa1384bd481a1cee3db4c68d7342a4e83ebd9112481f45ec4d3" => :sierra
    sha256 "7ab76d7cd519efb10a904e723e84151c2272de531c72725c98de52fe2501d3c8" => :el_capitan
  end

  head do
    url "https://gitlab.cern.ch/CLHEP/CLHEP.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
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

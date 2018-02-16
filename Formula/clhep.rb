class Clhep < Formula
  desc "Class Library for High Energy Physics"
  homepage "https://proj-clhep.web.cern.ch/proj-clhep/"
  url "https://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/clhep-2.4.0.2.tgz"
  sha256 "1e9891c5badb718c24933e7a5c6ee4d64fd4d5cf3a40c150ad18e864ec86b8a4"

  bottle do
    cellar :any
    sha256 "bd973452bfa422f5aa776f9d55707ae0bbc5b40543563e6e031dff285ef99d59" => :high_sierra
    sha256 "7652a1ff5a3f5300120b6968fbd081115cfb45014fc99ae522abc96d78a724f3" => :sierra
    sha256 "56367a9f81d026208bfa8e9a476df8b102a69f6ab48d689c5ddeb53b1beab4eb" => :el_capitan
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

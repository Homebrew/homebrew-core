class Clhep < Formula
  desc "Class Library for High Energy Physics"
  homepage "https://proj-clhep.web.cern.ch/proj-clhep/"
  url "https://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/clhep-2.4.0.2.tgz"
  sha256 "1e9891c5badb718c24933e7a5c6ee4d64fd4d5cf3a40c150ad18e864ec86b8a4"

  bottle do
    cellar :any
    sha256 "754687becb24c2cdab142198a54c741cd09256f9ac412047c5c6949fea5283a5" => :high_sierra
    sha256 "4c6fdba5cdee8966a39ea65a3fb7e3b0dcaa6207f2bd83dfadb2cc03a5b1040a" => :sierra
    sha256 "3baf470337b3d13cb6fd96b8c17e516986211869f7f02ca9c3c4563c44ca6139" => :el_capitan
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

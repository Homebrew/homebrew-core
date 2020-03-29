class Clhep < Formula
  desc "Class Library for High Energy Physics"
  homepage "https://proj-clhep.web.cern.ch/proj-clhep/"
  url "https://proj-clhep.web.cern.ch/proj-clhep/dist1/clhep-2.4.1.3.tgz"
  sha256 "27c257934929f4cb1643aa60aeaad6519025d8f0a1c199bc3137ad7368245913"

  bottle do
    cellar :any
    sha256 "8c8ce7164df92c63519e8d361f341ef848796cdd4087982e507f32d06952afbf" => :catalina
    sha256 "fda146a801791ab47ea095d0ba4d201de7fe52a23b90626e56f05aaeaf181a8f" => :mojave
    sha256 "7cd39923fcc37640a5f8bf841252c1f914494443aa5c359a6aa68a6e57ee9282" => :high_sierra
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

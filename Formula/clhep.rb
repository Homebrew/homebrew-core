class Clhep < Formula
  desc "Class Library for High Energy Physics"
  homepage "https://proj-clhep.web.cern.ch/proj-clhep/"
  url "https://proj-clhep.web.cern.ch/proj-clhep/DISTRIBUTION/tarFiles/clhep-2.4.1.0.tgz"
  sha256 "d14736eb5c3d21f86ce831dc1afcf03d423825b35c84deb6f8fd16773528c54d"

  bottle do
    cellar :any
    sha256 "c067826cdae1e029b9e08a21e485484ad11947394060ffce21247d6f638dc49e" => :mojave
    sha256 "ce6e421df5e06d3f85bc36c9eb4bb1e5ee5635d2a7b6a5c28d04490c12deb155" => :high_sierra
    sha256 "3cfaf1bea915e52b57c44d7df7c40312fb7e0fab6cac5b8a8310ac4dcc55b74d" => :sierra
    sha256 "4be2ee76db5d27890df9f0237e7c0342bcfae9f622dd3bfa156f6bbd79a2a2ee" => :el_capitan
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

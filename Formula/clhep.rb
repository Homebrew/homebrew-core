class Clhep < Formula
  desc "Class Library for High Energy Physics"
  homepage "https://proj-clhep.web.cern.ch/proj-clhep/"
  url "https://proj-clhep.web.cern.ch/proj-clhep/dist1/clhep-2.4.4.2.tgz"
  sha256 "0782964fc19f06b55998a091d5a0b70e1adb682f6c062bcb5a25467a2c060e8d"
  license "GPL-3.0"

  livecheck do
    url :homepage
    regex(%r{atest release.*?<b>v?(\d+(?:\.\d+)+)</b>}im)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "bb4176442facaae5d335409ef825aab4a561a4d3a59316c04b66268d49f9d808"
    sha256 cellar: :any, big_sur:       "73ed5e5dcdf0b6d8b50f91cb6e8839fb967be25a02f8374e185cc1cdc6718dce"
    sha256 cellar: :any, catalina:      "e441759f93337bcadd69460a709ec0adc4c1655fdf1677893471f7497d840bac"
    sha256 cellar: :any, mojave:        "77c920470ac55af4f79d2b6fced83301cbe187c13b2e238ab637d9bceb642120"
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
    system ENV.cxx, "-std=c++11", "-L#{lib}", "-lCLHEP", "-I#{include}/CLHEP",
           testpath/"test.cpp", "-o", "test"
    assert_equal "r: 3.74166 phi: 1.10715 cos(theta): 0.801784",
                 shell_output("./test").chomp
  end
end

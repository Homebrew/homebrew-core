class Clhep < Formula
  desc "Class Library for High Energy Physics"
  homepage "https://proj-clhep.web.cern.ch/proj-clhep/"
  url "https://proj-clhep.web.cern.ch/proj-clhep/dist1/clhep-2.4.4.0.tgz"
  sha256 "5df78c11733a091da9ae5a24ce31161d44034dd45f20455587db85f1ca1ba539"
  license "GPL-3.0"

  head do
    url "https://gitlab.cern.ch/CLHEP/CLHEP.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  livecheck do
    url :homepage
    regex(%r{atest release.*?<b>v?(\d+(?:\.\d+)+)</b>}im)
  end

  bottle do
    cellar :any
    sha256 "8d74340c61103f296ca7669e6640f9e5d31cc738594c677985e783e72e3227e0" => :big_sur
    sha256 "37bd90211267de309e2c6888aecac135202d3430a269aaf693307695341a92a8" => :arm64_big_sur
    sha256 "029450b4260d87bffc05d876e62a5fb51b285757c8e589debc609728e71c0da2" => :catalina
    sha256 "abf5e7c7c0490a2f82eaf5654670db7e5b0f38df0e9d739d28d233343e54f129" => :mojave
    sha256 "6a643d6bc0031270e6a85f4cb2f7e66e18e22c9925988f191384ec3dea90f1e7" => :high_sierra
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

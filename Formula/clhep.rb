class Clhep < Formula
  desc "Class Library for High Energy Physics"
  homepage "https://proj-clhep.web.cern.ch/proj-clhep/"
  url "https://proj-clhep.web.cern.ch/proj-clhep/dist1/clhep-2.4.6.0.tgz"
  sha256 "e8d16debb84ced28e40e9ae84789cf5a0adad45f9213fbac3ce7583e06caa7b1"
  license "GPL-3.0-only"
  head "https://gitlab.cern.ch/CLHEP/CLHEP.git", branch: "develop"

  livecheck do
    url :homepage
    regex(%r{atest release.*?<b>v?(\d+(?:\.\d+)+)</b>}im)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c7407a03055e1207f9051fdde09916256edb04a84654228c2aea7945381fb0a4"
    sha256 cellar: :any,                 arm64_big_sur:  "70be57bfdee2c6db3aac6cf9d219aeb71ccc333ff725bc4686f1facb3df632eb"
    sha256 cellar: :any,                 monterey:       "ea047e3fe0a24855e12d9b7b2b48edf72694e2efba17387ef5141a3e2bb8bdc7"
    sha256 cellar: :any,                 big_sur:        "5798f6ea7540f4e07f340cbc138786768c9eab676042beb6c89871aa0a92001e"
    sha256 cellar: :any,                 catalina:       "db57d799c9af8397ad4175cd59ab0e75407bc88385ed595ea57b7cf690a862a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a2baac370a6e9b05ee01e4629f45b918f9d33a2df5de5a1f93cb1e0442eb806"
  end

  depends_on "cmake" => :build

  def install
    (buildpath/"CLHEP").install buildpath.children if build.head?
    system "cmake", "-S", "CLHEP", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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

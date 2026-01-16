class Coordgen < Formula
  desc "Schrodinger-developed 2D Coordinate Generation"
  homepage "https://github.com/schrodinger/coordgenlibs"
  url "https://github.com/schrodinger/coordgenlibs/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "f67697434f7fec03bca150a6d84ea0e8409f6ec49d5aab43badc5833098ff4e3"
  license "BSD-3-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b6016edb22f9c1467d088684311a5de1a03f156031c99884f5a04bd55b4b368f"
    sha256 cellar: :any,                 arm64_sequoia: "f3291f603f1f55c41163e4acab534a3fc8fb192582deff462ec8894764ba5bb9"
    sha256 cellar: :any,                 arm64_sonoma:  "fc7b1c0c8932a1a8a254c4091a749de3d78d34103a666478ff62ce9f0e0abac8"
    sha256 cellar: :any,                 arm64_ventura: "eaa02e2c8e3b39f293800cb03bd5bac05306e852725dca1d65592c1a655d2abb"
    sha256 cellar: :any,                 sonoma:        "aec4514a4bb6382e5570aaab3970f1b4bc326d47eec90d82650fd58f37c32150"
    sha256 cellar: :any,                 ventura:       "0fe50a8d4e7c4a55ac999494491ea9eb246bf8610d22e5f57697d92a9978a2f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd0cef4b484abbdb1a50646919aedd7e34dd3dab36e460b90a3bc0e5b7c31e26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff923bc755c574b2b66e0e70123d183dfbe781db2aedc2ec47451c5a7b1586d3"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "maeparser"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", # https://github.com/schrodinger/coordgenlibs/pull/130
                    "-DCOORDGEN_BUILD_EXAMPLE=OFF",
                    "-DCOORDGEN_BUILD_TESTS=OFF",
                    "-DCOORDGEN_USE_MAEPARSER=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <coordgen/sketcherMinimizer.h>

      int main() {
        sketcherMinimizer minimizer;
        auto* min_mol = new sketcherMinimizerMolecule();
        auto a1 = min_mol->addNewAtom();
        a1->setAtomicNumber(7);
        auto a2 = min_mol->addNewAtom();
        a2->setAtomicNumber(6);
        auto b1 = min_mol->addNewBond(a1, a2);
        b1->setBondOrder(1);
        minimizer.initialize(min_mol);
        minimizer.runGenerateCoordinates();
        auto c1 = a1->getCoordinates();
        auto c2 = a2->getCoordinates();
        std::cout << c1 << "  " << c2;
        return 0;
      }
    CPP

    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-L#{lib}", "-lcoordgen"
    assert_equal "(-50, 0)  (0, 0)", shell_output("./test")
  end
end

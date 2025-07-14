class Minuit2 < Formula
  desc "Physics analysis tool for function minimization"
  homepage "https://root.cern.ch/doc/master/Minuit2Page.html"
  url "https://root.cern.ch/download/root_v6.36.02.source.tar.gz"
  sha256 "510d677b33ac7ca48aa0d712bdb88d835a1ff6a374ef86f1a1e168fa279eb470"
  license "LGPL-2.1-or-later"
  head "https://github.com/root-project/root.git", branch: "master"

  livecheck do
    formula "root"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5ceb10e033579a3fccc5903a2ffb6f990b8cda3cd9321b624647220cdd79be91"
    sha256 cellar: :any,                 arm64_sonoma:  "1b276c08fa9c78cda1de0b3ac53c6ca43b583d058f46b9754d027a1cad9dafbe"
    sha256 cellar: :any,                 arm64_ventura: "87cb7d6146ff81f1b76c3338df302aba760c16aadaa68b0a987f6044b687cdd2"
    sha256 cellar: :any,                 sonoma:        "c8d4ed8de59adac6c494723cb1602d045cddac7790d906e3e0bb96628f758684"
    sha256 cellar: :any,                 ventura:       "532725f45866f4033af99d61fa92b0b6b68805fc47610d1f7bc10ba2c75a956c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2862ac5492c094fa787c8064443ab8cfe854eb7583fb441a35efcf441c8e29f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f5155ba166a3be96619fd6aaa733a7d139a9754809dafc345263bb8773a98ea"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", "math/minuit2", "-B", "build/shared", *std_cmake_args,
                    "-Dminuit2_standalone=ON", "-DCMAKE_CXX_FLAGS='-std=c++14'", "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", "math/minuit2", "-B", "build/static", *std_cmake_args,
                    "-Dminuit2_standalone=ON", "-DCMAKE_CXX_FLAGS='-std=c++14'", "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build/static"
    lib.install Dir["build/static/lib/libMinuit2*.a"]

    pkgshare.install "math/minuit2/test/MnTutorial"
  end

  test do
    cp Dir[pkgshare/"MnTutorial/{Quad1FMain.cxx,Quad1F.h}"], testpath
    system ENV.cxx, "-std=c++14", "Quad1FMain.cxx", "-o", "test", "-I#{include}/Minuit2", "-L#{lib}", "-lMinuit2"
    assert_match "par0: -8.26907e-11 -1 1", shell_output("./test")
  end
end

class Minuit2 < Formula
  desc "Physics analysis tool for function minimization"
  homepage "https://root.cern.ch/doc/master/Minuit2Page.html"
  url "https://root.cern.ch/download/root_v6.30.02.source.tar.gz"
  sha256 "7965a456d1ad1ee0d5fe4769bf5a8fec291af684ed93db0f3080a9c362435183"
  license "LGPL-2.1-or-later"
  head "https://github.com/root-project/root.git", branch: "master"

  livecheck do
    formula "root"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "372b6cc373807caa831565296bc78da73b9adfac810e2bd8cc4236b4c4b4ff1d"
    sha256 cellar: :any,                 arm64_ventura:  "abe92b317e61d3a2eb9bbe0da2373403cb72ff65ca641bce2bc220e5d5fdca32"
    sha256 cellar: :any,                 arm64_monterey: "8a37e38cb7b07af5d049c1c03dac34feb120af5b6a2aa6eb9ac60bdcf0010330"
    sha256 cellar: :any,                 sonoma:         "825216002e5be60d60e5d12e1d7715091ac1c7f97e1a80fc4bff7284c17b02c3"
    sha256 cellar: :any,                 ventura:        "d5038b5036cefcc0faacb3c7f453c538d43e986621c4d2015bcfc058797620da"
    sha256 cellar: :any,                 monterey:       "4a6515d1d41ae6a26ad80422165c9411045d5439c32f8596b987c317a55ce569"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5474a1c7c17c66779d637b5f811e4ba0972b4389b84ed6e200c49b8b575752cc"
  end

  depends_on "cmake" => :build

  fails_with gcc: "5" # C++17

  def install
    system "cmake", "-S", "math/minuit2", "-B", "build/shared", *std_cmake_args,
                    "-Dminuit2_standalone=ON", "-DCMAKE_CXX_FLAGS='-std=c++17'", "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", "math/minuit2", "-B", "build/static", *std_cmake_args,
                    "-Dminuit2_standalone=ON", "-DCMAKE_CXX_FLAGS='-std=c++17'", "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build/static"
    lib.install Dir["build/static/lib/libMinuit2*.a"]

    pkgshare.install "math/minuit2/test/MnTutorial"
  end

  test do
    cp Dir[pkgshare/"MnTutorial/{Quad1FMain.cxx,Quad1F.h}"], testpath
    system ENV.cxx, "-std=c++17", "Quad1FMain.cxx", "-o", "test", "-I#{include}/Minuit2", "-L#{lib}", "-lMinuit2"
    assert_match "par0: -8.26907e-11 -1 1", shell_output("./test")
  end
end

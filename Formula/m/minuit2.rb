class Minuit2 < Formula
  desc "Physics analysis tool for function minimization"
  homepage "https://root.cern.ch/doc/master/md_math_minuit2_doc_Minuit2.html"
  url "https://root.cern.ch/download/root_v6.26.06.source.tar.gz"
  sha256 "b1f73c976a580a5c56c8c8a0152582a1dfc560b4dd80e1b7545237b65e6c89cb"
  license "LGPL-2.1-or-later"
  head "https://github.com/root-project/root.git", branch: "master"

  livecheck do
    formula "root"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2f7d577acba62cc976fa3c653eb12cc499054fd0fdc23d96ee1ce61c0792aa2e"
    sha256 cellar: :any,                 arm64_monterey: "6e205879629a898f1a797da87058b2cd7f727b5a5f21742af6227c74542977c0"
    sha256 cellar: :any,                 arm64_big_sur:  "937bc1d4b5613eadde5eb9b8706509ac46fba4b213df914b3a34f0b9645f9e8a"
    sha256 cellar: :any,                 ventura:        "1038f1c50451e93a9195bf3fedd9b206da67c5d0981787ce29ca15c093431931"
    sha256 cellar: :any,                 monterey:       "4738710f5a36f8c52c56650f6a7f6b5ed9470ad9d9fa8f1a5aaf2c9292bcb269"
    sha256 cellar: :any,                 big_sur:        "d5d4d4ce8c56607be1a02cbb2703d396cda084c04cef18be6cd6665364478ab4"
    sha256 cellar: :any,                 catalina:       "13bf91dd19a6a1a2eb4a291cca8cc07e00b79fca07896216f15e09b2ae90a0e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b5ea379da72fbca8dc6af5079d08dcdec09879a14abb0f1a52b6a9a1cd293f1"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", "math/minuit2", "-B", "build/shared", *std_cmake_args,
                    "-Dminuit2_standalone=ON", "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", "math/minuit2", "-B", "build/static", *std_cmake_args,
                    "-Dminuit2_standalone=ON", "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build/static"
    lib.install Dir["build/static/lib/libMinuit2*.a"]

    pkgshare.install "math/minuit2/test/MnTutorial"
  end

  test do
    cp Dir[pkgshare/"MnTutorial/{Quad1FMain.cxx,Quad1F.h}"], testpath
    system ENV.cxx, "-std=c++11", "Quad1FMain.cxx", "-o", "test", "-I#{include}/Minuit2", "-L#{lib}", "-lMinuit2"
    assert_match "par0: -8.26907e-11 -1 1", shell_output("./test")
  end
end

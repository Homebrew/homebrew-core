class Minuit2 < Formula
  desc "Physics analysis tool for function minimization"
  homepage "https://root.cern.ch/doc/master/md_math_minuit2_doc_Minuit2.html"
  url "https://root.cern.ch/download/root_v6.26.04.source.tar.gz"
  sha256 "a271cf82782d6ed2c87ea5eef6681803f2e69e17b3036df9d863636e9358421e"
  license "LGPL-2.1-or-later"
  head "https://github.com/root-project/root.git", branch: "master"

  livecheck do
    formula "root"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c8294f858a51417818bffa6cbad7cca30eec2324706a5c20a8ddafd83cf4ddde"
    sha256 cellar: :any,                 arm64_big_sur:  "49c71ca4fadc8a741643535b8583380a5ffc417da545037a9ab15927a2f0cabb"
    sha256 cellar: :any,                 monterey:       "75eda5e1e49e61dc127bafdbe2aaa426b65406bf43a41d04c603e21926011360"
    sha256 cellar: :any,                 big_sur:        "8706c30aa0202ecae56bf86276c6b66f9384be2518e6e39aeae302157c6faaed"
    sha256 cellar: :any,                 catalina:       "786d6e3ac1bd9901115c8fdcd7473933cfce3984cd193c1cf169333a272289f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8da331f7912a1e04e15d8c53b5538a081275afbdd6677b997da747e6f5e03d3c"
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

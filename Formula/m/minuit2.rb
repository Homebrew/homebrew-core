class Minuit2 < Formula
  desc "Physics analysis tool for function minimization"
  homepage "https://root.cern.ch/doc/master/Minuit2Page.html"
  url "https://root.cern.ch/download/root_v6.38.04.source.tar.gz"
  sha256 "1ca561d03b3addae00cb76af57f8c75d3c229e8bd6939bdd408ec33fda9d3487"
  license "LGPL-2.1-or-later"
  head "https://github.com/root-project/root.git", branch: "master"

  livecheck do
    formula "root"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2d54068117e8154f7776195ae733e3e84248b1ce299bce5cf9db862785375313"
    sha256 cellar: :any,                 arm64_sequoia: "739ca6a23c37bf68510c2aa5f64576e31d93e9f5d4f4bbf7aab17e55c62effb7"
    sha256 cellar: :any,                 arm64_sonoma:  "5346bd0a6cd0a0cdaee3c96217b67aed8f117ef75a84dd45976034092da28906"
    sha256 cellar: :any,                 sonoma:        "6a3c7b50bdb7a0378e5c57cf9e4e8529fcdcfbde148c1aab8f9f8317ff6fd831"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "046ee37136a470df335fd6a5601c0c17ebeac20230b40b3e5793c2ef817830c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9674d3dc7961fdee7ab64a87d54b61ce05c88dbcb5491540f59ce92a9e6af116"
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

class Minuit2 < Formula
  desc "Physics analysis tool for function minimization"
  homepage "https://root.cern.ch/doc/master/Minuit2Page.html"
  url "https://root.cern.ch/download/root_v6.30.04.source.tar.gz"
  sha256 "2b4180b698f39cc65d91084d833a884515b325bc5f673c8e39abe818b025d8cc"
  license "LGPL-2.1-or-later"
  head "https://github.com/root-project/root.git", branch: "master"

  livecheck do
    formula "root"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cf247eb89f805fc1819e541aea98cabd26abdaa0d3d9be7aefd45c038f0a9f2d"
    sha256 cellar: :any,                 arm64_ventura:  "a47309a7890d35acfe63fd66c9cb3faffe7e47402bdc4675587e45cd4e320d0d"
    sha256 cellar: :any,                 arm64_monterey: "549665458616030d29ac3774ece0785a2f2bed085d19ccf49779257545a5166b"
    sha256 cellar: :any,                 sonoma:         "55d14e525611ec8c2ae24eeede50bfbed5fa992d7c480cd592f0fee9131507fa"
    sha256 cellar: :any,                 ventura:        "0f3542fa69d03f41235bf65a478b1e356885d9cecf559cf57e50f7773ceca240"
    sha256 cellar: :any,                 monterey:       "2765ca09ce8db3b99e9988e1d7b941c76134ad685faeafee3a4a288a9ea23f4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "735dfbb932f8fd00502f60e2ba6f004e3e4489c613873ccd639b429dfa2a5bb7"
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

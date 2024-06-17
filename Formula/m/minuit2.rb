class Minuit2 < Formula
  desc "Physics analysis tool for function minimization"
  homepage "https://root.cern.ch/doc/master/Minuit2Page.html"
  url "https://root.cern.ch/download/root_v6.32.00.source.tar.gz"
  sha256 "12f203681a59041c474ce9523761e6f0e8861b3bee78df5f799a8db55189e5d2"
  license "LGPL-2.1-or-later"
  head "https://github.com/root-project/root.git", branch: "master"

  livecheck do
    formula "root"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cb5f1188a4a253eb0917fa00ff5449bf26db868362457c4bb67b2d76070c2f66"
    sha256 cellar: :any,                 arm64_ventura:  "249ca4d57d142a83ce3da1b185975bccaec7e7e451c6462591cef6f5e3bedb36"
    sha256 cellar: :any,                 arm64_monterey: "2ac398b0f7b1163cfd827c3a6ea6d5f88c9b9a16703921f9c9b58e746e70ae11"
    sha256 cellar: :any,                 sonoma:         "9d7855cf2d1328b77b6f41194cbfba8f3de618f30642f9d7d0473154a93d5f58"
    sha256 cellar: :any,                 ventura:        "a7c7d7e2e5d97ed2b18477250f70b1427070ac0c47b774417ab73b3efa3398d3"
    sha256 cellar: :any,                 monterey:       "ebcb5e3b1e839c2420bac6b2a432dcd86529ec02532c2f7ed996c6ca8d812620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2517bcd4fae7fb71360eb3cf3f34b2a7c22fc8e588c1e8313695e6f526505900"
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

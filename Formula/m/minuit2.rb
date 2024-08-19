class Minuit2 < Formula
  desc "Physics analysis tool for function minimization"
  homepage "https://root.cern.ch/doc/master/Minuit2Page.html"
  url "https://root.cern.ch/download/root_v6.32.04.source.tar.gz"
  sha256 "132f126aae7d30efbccd7dcd991b7ada1890ae57980ef300c16421f9d4d07ea8"
  license "LGPL-2.1-or-later"
  head "https://github.com/root-project/root.git", branch: "master"

  livecheck do
    formula "root"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3213b214ac223a5f62a3732a66253c29c412301f53f084d3a95a8c9e1d19649a"
    sha256 cellar: :any,                 arm64_ventura:  "e6a20d02c445e4162ca9e76f9190942e68034c8c7ed58ae2a375d121b926ad98"
    sha256 cellar: :any,                 arm64_monterey: "45042b0c93bc888463851dc66e19582a1ccda8bc58efe8775724d906c16f87ea"
    sha256 cellar: :any,                 sonoma:         "054e54d46c3512d2c473c4221891b58db8e6852b43af1fed13939fdba96a53fe"
    sha256 cellar: :any,                 ventura:        "d4ee117fcece6d21377bbd42956bd3ec34444aec76f33627ad50950a2113285c"
    sha256 cellar: :any,                 monterey:       "01f493de4074d88ad4bc702b939c8c6ccfdb71b7ec1471f3e9aa4f005f64b009"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "255c6ed410df23f0368a6d108b64e3c6992eb8146c92818efc240579ec7da609"
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

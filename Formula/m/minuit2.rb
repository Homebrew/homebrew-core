class Minuit2 < Formula
  desc "Physics analysis tool for function minimization"
  homepage "https://root.cern.ch/doc/master/Minuit2Page.html"
  url "https://root.cern.ch/download/root_v6.30.06.source.tar.gz"
  sha256 "300db7ed1b678ed2fb9635ca675921a1945c7c2103da840033b493091f55700c"
  license "LGPL-2.1-or-later"
  head "https://github.com/root-project/root.git", branch: "master"

  livecheck do
    formula "root"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3b27b1110a34463a46b9ded345df69cf999fb5cf9428324391023e8dfcf92d7b"
    sha256 cellar: :any,                 arm64_ventura:  "21c1b88dcc68aa0585c58d748c7a93e8c33b21b17c80df7b1d7822f155b97d25"
    sha256 cellar: :any,                 arm64_monterey: "4564232bfa9baae773ec8213847cd4be2c06f8b088dce5eefd4f4a5a6e408233"
    sha256 cellar: :any,                 sonoma:         "9661010dbc28e0f98bb46e0d47f18bcc07ffc034be409ca91e7528d1dd289c62"
    sha256 cellar: :any,                 ventura:        "295ecac724774a5c88e3c165944a4873d65560d81d56f4b192901203c19a8a66"
    sha256 cellar: :any,                 monterey:       "eefac2400e792ce9f3fd0ea821f570a93a48a7c3cdfba3a2c087c03d168efca3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd4736c620d724655a4b985d303c5b7166e486ee6d445056359e892fe622259a"
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

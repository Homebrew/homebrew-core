class Cminpack < Formula
  desc "Solves nonlinear equations and nonlinear least squares problems"
  homepage "http://devernay.free.fr/hacks/cminpack/cminpack.html"
  url "https://github.com/devernay/cminpack/archive/v1.3.8.tar.gz"
  sha256 "3ea7257914ad55eabc43a997b323ba0dfee0a9b010d648b6d5b0c96425102d0e"
  license "BSD-3-Clause"
  head "https://github.com/devernay/cminpack.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "77fb555fafcface498156afafaee3303660b548bcb813dd381443457701e4c3a"
    sha256 cellar: :any,                 arm64_big_sur:  "d508c68c13b468c31d533289722929544c43a01e3c24082d6a58b02fb8dd875d"
    sha256 cellar: :any,                 monterey:       "13c06f84c13a6c57c659d19ae277da7ebc8306536050b8952dadf88da7d4d35c"
    sha256 cellar: :any,                 big_sur:        "42feed7d547bfc20b5665c9e28b68a4a059f8791f56830ddd5e004a12d363784"
    sha256 cellar: :any,                 catalina:       "adfd9f1a494a35c87c9d6e04a7f10371fa3a1107fa3f2dfeb67c40b87d07dadb"
    sha256 cellar: :any,                 mojave:         "04a82ea734b10f9600b3bd3c4390d213f34eade2ec375784c1083e755548274c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e78fde611720ec7d338383afd4deb5095517ab2a1a012763d8024db7b58fa84"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=ON",
                         "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON",
                         "-DCMINPACK_LIB_INSTALL_DIR=lib",
                         *std_cmake_args
    system "make", "install"

    man3.install Dir["doc/*.3"]
    doc.install Dir["doc/*"]
    pkgshare.install "examples/thybrdc.c"
  end

  test do
    system ENV.cc, "-I#{include}/cminpack-1", pkgshare/"thybrdc.c",
                   "-L#{lib}", "-lcminpack", "-lm", "-o", "test"
    assert_match "number of function evaluations", shell_output("./test")
  end
end

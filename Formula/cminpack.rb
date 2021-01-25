class Cminpack < Formula
  desc "Solves nonlinear equations and nonlinear least squares problems"
  homepage "http://devernay.free.fr/hacks/cminpack/cminpack.html"
  url "https://github.com/devernay/cminpack/archive/v1.3.7.tar.gz"
  sha256 "b891f33ffcfb8b246bb6147a4da6308cdb2386ca42a99892ff9b2e884f8b0386"
  license "BSD-3-Clause"
  head "https://github.com/devernay/cminpack.git"

  bottle do
    cellar :any
    sha256 "86d43532f7780d59fa03678ef2c292bfd1008cb93d0a218e6f910260aa41a2b2" => :big_sur
    sha256 "980cf16c3b6a73e2642a3ea91a2fce13939f7108d909f25318481b006390d11f" => :arm64_big_sur
    sha256 "5ca34e952085713f2afe3a21c8bf814bbd769aef29c4ade57d0d0545c8479b6f" => :catalina
    sha256 "ee0d22eff273b198c9392c33c14a57a53d9a7cf7332ae5019055332addd4c235" => :mojave
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=ON",
                         "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON",
                         *std_cmake_args
    system "make", "install"

    man3.install Dir["doc/*.3"]
    doc.install Dir["doc/*"]
    pkgshare.install "examples/thybrdc.c"
  end

  test do
    system ENV.cc, pkgshare/"thybrdc.c", "-o", "test",
                   "-I#{include}/cminpack-1", "-L#{lib}", "-lcminpack", "-lm"
    assert_match "number of function evaluations", shell_output("./test")
  end
end

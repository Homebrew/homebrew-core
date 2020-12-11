class Cminpack < Formula
  desc "Solves nonlinear equations and nonlinear least squares problems"
  homepage "http://devernay.free.fr/hacks/cminpack/cminpack.html"
  url "https://github.com/devernay/cminpack/archive/v1.3.7.tar.gz"
  sha256 "b891f33ffcfb8b246bb6147a4da6308cdb2386ca42a99892ff9b2e884f8b0386"
  license "BSD-3-Clause"
  head "https://github.com/devernay/cminpack.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "50f427121fa86f4f7e438ac8d726878c3207c5ee23d673ddd29de33841a92be4" => :big_sur
    sha256 "4b84066225947b0be564dee31f170bd7ca199f7d4d79a5d36856dfaa50274b3c" => :catalina
    sha256 "ed324431e08d77b33855bea05a3c3ea719991d80f5eb79b97b32e624ea6a82b2" => :mojave
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

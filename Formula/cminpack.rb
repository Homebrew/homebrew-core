class Cminpack < Formula
  desc "Solves nonlinear equations and nonlinear least squares problems"
  homepage "http://devernay.free.fr/hacks/cminpack/cminpack.html"
  url "https://github.com/devernay/cminpack/archive/v1.3.6.tar.gz"
  sha256 "3c07fd21308c96477a2c900032e21d937739c233ee273b4347a0d4a84a32d09f"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/devernay/cminpack.git"

  bottle do
    cellar :any
    sha256 "f01181d9cd0882df08500e79b24c98a0d101579592684fe151fac5efa4e34835" => :catalina
    sha256 "4ee55e748a0b20cf6450c88beaf821fd962e78c81c640a569720c0831b653ac0" => :mojave
    sha256 "07714bb85b22bf0a9408337520ec68ac1ebbf4141070319e26975b641b936cd2" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=ON",
                         "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON",
                         *std_cmake_args
    system "make", "install"

    man3.install Dir["doc/*.3"]
    doc.install Dir["doc/*"]
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/thybrdc.c", testpath
    system ENV.cc, pkgshare/"examples/thybrdc.c", "-o", "test",
                   "-I#{include}/cminpack-1", "-L#{lib}", "-lcminpack", "-lm"
    assert_match "number of function evaluations", shell_output("./test")
  end
end

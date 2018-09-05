class Cminpack < Formula
  desc "Solves nonlinear equations and nonlinear least squares problems"
  homepage "http://devernay.free.fr/hacks/cminpack/cminpack.html"
  url "https://github.com/devernay/cminpack/archive/v1.3.6.tar.gz"
  sha256 "3c07fd21308c96477a2c900032e21d937739c233ee273b4347a0d4a84a32d09f"
  head "https://github.com/devernay/cminpack.git"

  bottle do
    cellar :any
    sha256 "414aa14e16da767cfb9559b5293f1bb46ca1e3c326905611e69fe59bd3e415d3" => :mojave
    sha256 "32a6b48cfe87b229bb1529a7c895762a5f3fa50b30703260ccca724c6af72a2a" => :high_sierra
    sha256 "16664c7714c7e4337d453cc709dcee658662b7b61735608a278d81314557a08f" => :sierra
    sha256 "ea2b1e1a4d1323e47df94c5fff2b66a8d3ecd2800f5f1dab788994e37192c628" => :el_capitan
    sha256 "83b0004c7f4a707f51ee402f9d99f85f3c2d7f865c33f96f0a7ee85abfdb8ec1" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
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

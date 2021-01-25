class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/gammaray"
  url "https://github.com/KDAB/GammaRay/releases/download/v2.11.2/gammaray-2.11.2.tar.gz"
  sha256 "bba4f21a2bc81ec8ab50dce5218c7a375b92d64253c690490a6fcb384c2ff9f3"
  license "GPL-2.0-or-later"
  head "https://github.com/KDAB/GammaRay.git"

  bottle do
    cellar :any
    sha256 "4fe8a8cb2c8f9c534ffb0272a9ff251e47ff2e933b8fa25a000724ffbce9d0fc" => :big_sur
    sha256 "d4e162e858e6a20f37ffa06b5e615ae14d8271ddd37669c16baa7d348635629e" => :arm64_big_sur
    sha256 "ec6ed993cf1a0c29f82afbb1ecb9172e04a333e809754821e4be0cef6477db07" => :catalina
    sha256 "4083804c1fb3ad5e49a3ae646d4d83f7d20fef40ed0a0b51e0d1ae3baa043f90" => :mojave
    sha256 "35610f498837c932f55a0d4fdf3c2cfb7992976ae8ef489bb49031ab293bdd38" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "graphviz"
  depends_on "qt"

  def install
    # For Mountain Lion
    ENV.libcxx

    system "cmake", *std_cmake_args,
                    "-DCMAKE_DISABLE_FIND_PACKAGE_Graphviz=ON",
                    "-DCMAKE_DISABLE_FIND_PACKAGE_VTK=OFF"
    system "make", "install"
  end

  test do
    assert_predicate prefix/"GammaRay.app/Contents/MacOS/gammaray", :executable?
  end
end

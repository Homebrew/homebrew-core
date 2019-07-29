class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/kdab-products/gammaray/"
  url "https://github.com/KDAB/GammaRay/releases/download/v2.11.0/gammaray-2.11.0.tar.gz"
  sha256 "ab0488d2178c532816d491ab361ac3d362590f0e63912f7198f34c1b582209ca"
  head "https://github.com/KDAB/GammaRay.git"

  bottle do
    cellar :any
    sha256 "3efdda21f9a32efef5dc78367e2b0bafae12793fab0e387d426ac3631842c7b4" => :mojave
    sha256 "317874bb7746f5f992984ae9deb89338d852565d6e08b46788d7a2d8e7fcee59" => :high_sierra
    sha256 "ebab58973253ea91221d628922d55a2e60db306170970d770ac53f8c9a50821e" => :sierra
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

class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/kdab-products/gammaray/"
  url "https://github.com/KDAB/GammaRay/releases/download/v2.10.0/gammaray-2.10.0.tar.gz"
  sha256 "0554e43067c2eba3517cf746a921385cf15675db79f879e1c3a7851c4951ffbe"
  head "https://github.com/KDAB/GammaRay.git"

  bottle do
    sha256 "f6328e7d1fc47b5853b124fdbbc4c11f80ad5856c42cd1797bc6e0485cf8475b" => :mojave
    sha256 "90dea0a6374d27a768d2ad6d5cf4b70751199924d2dfb6d47af71fd2d638bb8a" => :high_sierra
    sha256 "96fbf0b78d74f59b2be7399aa0a2a5f0c2d89629e930ef236e2280d514914218" => :sierra
    sha256 "d3295f75b82219d58cd8f529e6f0e72bf8d798321f50b55ba7418af48b624060" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "graphviz"
  depends_on "qt"

  needs :cxx11

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

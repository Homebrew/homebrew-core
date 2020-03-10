class Gammaray < Formula
  desc "Examine and manipulate Qt application internals at runtime"
  homepage "https://www.kdab.com/gammaray"
  url "https://github.com/KDAB/GammaRay/releases/download/v2.11.1/gammaray-2.11.1.tar.gz"
  sha256 "87a1d72ad1ad6d1a0156c54a85b0976ab38c6a64136458ca7c4ee491566d25d0"
  head "https://github.com/KDAB/GammaRay.git"

  bottle do
    cellar :any
    sha256 "c6d0ef57b42ec3732e21e2c2971d248cfdcb2e46c97a89fe979055364204bb4e" => :catalina
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

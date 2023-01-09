class Field3d < Formula
  desc "Library for storing voxel data on disk and in memory"
  homepage "https://sites.google.com/site/field3d/"
  url "https://github.com/imageworks/Field3D/archive/v1.7.3.tar.gz"
  sha256 "b6168bc27abe0f5e9b8d01af7794b3268ae301ac72b753712df93125d51a0fd4"
  license "BSD-3-Clause"
  revision 9

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "01f10aea2d4feb02cf770ef2beb67d2603d43df433d5e5b922045e9e2f92af38"
    sha256 cellar: :any,                 arm64_monterey: "2f8a59f6d8f8eec9b1dd0946876bb4304c0acf2d6f0a59316badd554bcf22f5c"
    sha256 cellar: :any,                 arm64_big_sur:  "e61de0782adecfc668e47fbec1158573dc0143b6a65f11dc837aa413902e5fd6"
    sha256 cellar: :any,                 ventura:        "58eb110354954de1ba4b9f1c81114cf128e5d3e1609b681964d5765364098483"
    sha256 cellar: :any,                 monterey:       "ec3eec933c2123f29d3aca93b5cf70cdd26187cb811f817d1ac2846a9fb6bfca"
    sha256 cellar: :any,                 big_sur:        "2fa65c2a7f992a9d979ff347dcce2c3d4f7a2061eb4820fa3961ad363d99e515"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6b7c036967955a85f3b22c2f924c85b36688f1b4c1e608df07393095c86bedf"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "hdf5"
  depends_on "ilmbase"

  fails_with gcc: "5"

  def install
    ENV.cxx11
    ENV.prepend "CXXFLAGS", "-DH5_USE_110_API"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DMPI_FOUND=OFF"
      system "make", "install"
    end
    man1.install "man/f3dinfo.1"
    pkgshare.install "contrib", "test", "apps/sample_code"
  end

  test do
    system ENV.cxx, "-std=c++11", "-I#{include}",
           pkgshare/"sample_code/create_and_write/main.cpp",
           "-L#{lib}", "-lField3D",
           "-I#{Formula["boost"].opt_include}",
           "-L#{Formula["boost"].opt_lib}", "-lboost_system",
           "-I#{Formula["hdf5"].opt_include}",
           "-L#{Formula["hdf5"].opt_lib}", "-lhdf5",
           "-I#{Formula["ilmbase"].opt_include}",
           "-o", "test"
    system "./test"
  end
end

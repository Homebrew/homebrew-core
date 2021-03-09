class Field3d < Formula
  desc "Library for storing voxel data on disk and in memory"
  homepage "https://sites.google.com/site/field3d/"
  url "https://github.com/imageworks/Field3D/archive/v1.7.3.tar.gz"
  sha256 "b6168bc27abe0f5e9b8d01af7794b3268ae301ac72b753712df93125d51a0fd4"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_big_sur: "6781d411f8cc234b6882e768bcbed5ae6dbb827a61083dff16d964fdf40e6622"
    sha256 cellar: :any, big_sur:       "46354c04b0cebfc7b54880b3e4ed3f9e57726dc773b4d8a0143f113c2c178da1"
    sha256 cellar: :any, catalina:      "b781b7f40b7aaff0ec9b05979ad9698f86c23ecc270a3ffa90475e7450088cbd"
    sha256 cellar: :any, mojave:        "4563833cb30bcb0194f018c9f9bf3f3b90c6f5ee803b414f33f4cf1df4f6889e"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "hdf5"
  depends_on "ilmbase"

  def install
    ENV.cxx11
    ENV.prepend "CXXFLAGS", "-DH5_USE_110_API"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    man1.install "man/f3dinfo.1"
    pkgshare.install "contrib", "test", "apps/sample_code"
  end

  test do
    system ENV.cxx, "-std=c++11", "-I#{include}", "-L#{lib}", "-lField3D",
           "-I#{Formula["boost"].opt_include}",
           "-L#{Formula["boost"].opt_lib}", "-lboost_system",
           "-I#{Formula["hdf5"].opt_include}",
           "-L#{Formula["hdf5"].opt_lib}", "-lhdf5",
           "-I#{Formula["ilmbase"].opt_include}",
           pkgshare/"sample_code/create_and_write/main.cpp",
           "-o", "test"
    system "./test"
  end
end

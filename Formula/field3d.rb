class Field3d < Formula
  desc "Library for storing voxel data on disk and in memory"
  homepage "https://sites.google.com/site/field3d/"
  url "https://github.com/imageworks/Field3D/archive/v1.7.3.tar.gz"
  sha256 "b6168bc27abe0f5e9b8d01af7794b3268ae301ac72b753712df93125d51a0fd4"
  license "BSD-3-Clause"
  revision 4

  bottle do
    sha256 cellar: :any, arm64_monterey: "da4a49105b11ec76fd729d107b9f2d4a2ab0ad3dc462d7d9570a48b4baaebaeb"
    sha256 cellar: :any, arm64_big_sur:  "b12b7bbffb37cac1a70220ad329743dbd1eb47c44e7229a8646d9b14124151f2"
    sha256 cellar: :any, monterey:       "d9c36b3f585c22752afc1cb4f8441439ea6de769e7bb44bc158821eddcba8e1a"
    sha256 cellar: :any, big_sur:        "90b0c9cc4ab05cfcbfa656aa634f808513d6f4e8f11a51f43d7a34abd8dd4f1f"
    sha256 cellar: :any, catalina:       "76d498d553b562262c1654c1cd717057eaf0bc78d03bbe20dfb3e55c55f5d5a4"
    sha256 cellar: :any, mojave:         "c5722c3960ff48af8007245cdf71a818d292ce76b85abf998c2a9623da3297a4"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "hdf5"
  depends_on "ilmbase"

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

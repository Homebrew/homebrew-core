class Field3d < Formula
  desc "Library for storing voxel data on disk and in memory"
  homepage "https://sites.google.com/site/field3d/"
  url "https://github.com/imageworks/Field3D/archive/v1.7.3.tar.gz"
  sha256 "b6168bc27abe0f5e9b8d01af7794b3268ae301ac72b753712df93125d51a0fd4"
  license "BSD-3-Clause"
  revision 3

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c89838aa0ae15362f20185876d52e26f2481cb81de1cc02af5afd14a0258ffe4"
    sha256 cellar: :any, big_sur:       "0b241420488c3114eb7be754d367ac304e5ee1f4eb0ced337e993a2f40cb2916"
    sha256 cellar: :any, catalina:      "c5762c0dcb2845b79128738c961a24320308b2fcd7b512d55229684fba01f3e6"
    sha256 cellar: :any, mojave:        "0d94886e981db690def40186348a61afff86722db9bcc5a7d1cdb31289b45d3f"
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

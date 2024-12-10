class Field3d < Formula
  desc "Library for storing voxel data on disk and in memory"
  homepage "https://sites.google.com/site/field3d/"
  url "https://github.com/imageworks/Field3D/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "b6168bc27abe0f5e9b8d01af7794b3268ae301ac72b753712df93125d51a0fd4"
  license "BSD-3-Clause"
  revision 11

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "badf01fe9f3ce3d876aa212afe849e2597ab7e7c0d881622895e73f7c05951ac"
    sha256 cellar: :any,                 arm64_ventura:  "84775376ed6d1d9031455dc9a9130570e65e0c804e1b8543679258a2ed735859"
    sha256 cellar: :any,                 arm64_monterey: "2a2c1c5b03675b4939e84e5f59e42e4b5ecec38961b8b187bb126c396b930aff"
    sha256 cellar: :any,                 arm64_big_sur:  "115d9cf5592fb883058ec8a1e51105a709d02aa0e6529aa7d3777f912ac602aa"
    sha256 cellar: :any,                 sonoma:         "5a8dc4b6678bbfb63f88a533adb4b50325e35f03a546906b9bc7e33a4a86e723"
    sha256 cellar: :any,                 ventura:        "25fb0a2d50d3cc64d7a5ad7db60aab7b4a988a507b8206c812f25cf6c19e0310"
    sha256 cellar: :any,                 monterey:       "0a3a952b86f24e779d0b0f2dca84574ab067b2c0bbbc83eba4ae1f1a223ba0fe"
    sha256 cellar: :any,                 big_sur:        "3c11ab54417b1f865a1d72197ab611617f132aeaf97b549a3f9881b06f13415a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5a36a8480ac6abb6537e774aed52c40a5de25536109050163e29edecf9e7a4a"
  end

  # Depends on deprecated `ilmbase` and upstream has been discussing
  # archiving repo in https://groups.google.com/g/field3d-dev/c/nBrVsNQ9SHo
  # Last release on 2020-03-11
  disable! date: "2024-02-07", because: :unmaintained

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

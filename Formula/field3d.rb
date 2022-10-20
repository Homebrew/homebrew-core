class Field3d < Formula
  desc "Library for storing voxel data on disk and in memory"
  homepage "https://sites.google.com/site/field3d/"
  url "https://github.com/imageworks/Field3D/archive/v1.7.3.tar.gz"
  sha256 "b6168bc27abe0f5e9b8d01af7794b3268ae301ac72b753712df93125d51a0fd4"
  license "BSD-3-Clause"
  revision 8

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5ccab64a1d8a3f1a709b4efd84e47be950a28b468cf4315eaed9c332fc0dd0c0"
    sha256 cellar: :any,                 arm64_big_sur:  "bdd3df3a156e09d0612b4266a4a7036baf3a8ebd99573c70fef4cb3fa3af595b"
    sha256 cellar: :any,                 monterey:       "4c854331b625741ed631440767b90ceb8dae7c565b19c1b909a35068e9635c8e"
    sha256 cellar: :any,                 big_sur:        "f7113a6ebab33c4591099ffa838d98cee8d72d8f0d2627a9e8a9c4783755fdc7"
    sha256 cellar: :any,                 catalina:       "c74402ddc431e94001cf07efe110c4085aa486fd024a470dd2bd0d00454aba46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37156c96c67dcf0b5fe46027c758e6172781503495dab9364b43cad3331dc28c"
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

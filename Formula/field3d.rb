class Field3d < Formula
  desc "Library for storing voxel data on disk and in memory"
  homepage "https://sites.google.com/site/field3d/"
  url "https://github.com/imageworks/Field3D/archive/v1.7.3.tar.gz"
  sha256 "b6168bc27abe0f5e9b8d01af7794b3268ae301ac72b753712df93125d51a0fd4"
  license "BSD-3-Clause"
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9d35aa85a559bc4be3e770c12ff1163861def00ee5fd7390a4d117df3bd7364e"
    sha256 cellar: :any,                 arm64_big_sur:  "8b93146f1cdd86071f2a3a9303253b98869710e910811fa787043fb8f283ee25"
    sha256 cellar: :any,                 monterey:       "a05b25cb2693f8e14c7ac302dd109be334b01b5cf10048ce4c7cd676c2d354ca"
    sha256 cellar: :any,                 big_sur:        "b121b972c65b471e1cf99f1b15788dc3b8b0e0e5542c07594893e3f6b35b292f"
    sha256 cellar: :any,                 catalina:       "bf284af39db627f2c3396ebb39c4977719b8d615ef78d251e9d2a55cfe3ce4cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49f575e761aace6ff76d07ad1c9f046af77abb3bfdb16d3caf8d7259ebcde9cc"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "hdf5"
  depends_on "ilmbase"

  on_linux do
    depends_on "gcc"
  end

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

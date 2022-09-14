class Field3d < Formula
  desc "Library for storing voxel data on disk and in memory"
  homepage "https://sites.google.com/site/field3d/"
  url "https://github.com/imageworks/Field3D/archive/v1.7.3.tar.gz"
  sha256 "b6168bc27abe0f5e9b8d01af7794b3268ae301ac72b753712df93125d51a0fd4"
  license "BSD-3-Clause"
  revision 7

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b39c3161c958937e66aa74d0ef7780a4e2df3d279fd834cddc011c930bbc401c"
    sha256 cellar: :any,                 arm64_big_sur:  "8be626af06a5963eefff00b617d732055ecc5c981aa9da4b3646f70874f92047"
    sha256 cellar: :any,                 monterey:       "08450558bd22e30ea9fbc0987f97d7cb08996c768df4da2f1622d369100cdc13"
    sha256 cellar: :any,                 big_sur:        "6e05fd88a91b386fdacaae1b18d2438ab3be3cbef44c0b98f83d09d9dfb5dc1d"
    sha256 cellar: :any,                 catalina:       "90a03036d21be5f0546ae00ecc8327e44704093aebe27d5055e9007a7a9bf0f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce229d05e72f9d75644f1a8afdf402ab38e902b6695df6eb95f7d74c136bcb38"
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

class Field3d < Formula
  desc "Library for storing voxel data on disk and in memory"
  homepage "https://sites.google.com/site/field3d/"
  url "https://github.com/imageworks/Field3D/archive/v1.7.3.tar.gz"
  sha256 "b6168bc27abe0f5e9b8d01af7794b3268ae301ac72b753712df93125d51a0fd4"
  license "BSD-3-Clause"
  revision 6

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "88a905e0624b4258f3a2b72c188b71f408e3494ef84ea7106439ceea4e173f2e"
    sha256 cellar: :any,                 arm64_big_sur:  "1129fd4858d6c9ba9535bc758681d8092fa2e1c53f638994db9f8d4c6aad7346"
    sha256 cellar: :any,                 monterey:       "96e373ed802ef6e5668f838557ba4ae81fab51fd2542b94b7b8f885b3697be26"
    sha256 cellar: :any,                 big_sur:        "9feff08c2928f0fee3944143abe5225ce33441a9ca4455caeea4553d3edc81ef"
    sha256 cellar: :any,                 catalina:       "ddbd16a395b93503bea2554c5f99a4afe79b526f2877172ed990c67fb84da204"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7dc5e45b851455b24583d55595662325bcd8d9712b80d64141e8db443b059dc"
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

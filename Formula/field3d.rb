class Field3d < Formula
  desc "Library for storing voxel data on disk and in memory"
  homepage "https://sites.google.com/site/field3d/"
  url "https://github.com/imageworks/Field3D/archive/v1.7.2.tar.gz"
  sha256 "8f7c33ecb4489ed626455cf3998d911a079b4f137f86814d9c37c5765bf4b020"
  revision 10

  bottle do
    cellar :any
    sha256 "a790934191e341047106165eff2a5f812f16114c9559d0f8986722a3a4991230" => :catalina
    sha256 "6a675590f02785539160e54cfb49ffc2b041da2b6276abcd2c67b56c85e805f9" => :mojave
    sha256 "82a33f663441303c0c8a9412e3e4c62a883a58ed2a1eda1981a41cd7d44b72c4" => :high_sierra
  end

  depends_on "scons" => :build
  depends_on "boost"
  depends_on "hdf5"
  depends_on "ilmbase"

  # Append C++11 flag to CXXFLAGS
  # https://github.com/imageworks/Field3D/pull/97
  patch do
    url "https://github.com/imageworks/Field3D/pull/97.diff?full_index=1"
    sha256 "a2fdd2a1d10fbf62c0ee67a6e1a63919dad8aa509004401d60de939315779288"
  end

  def install
    ENV.cxx11
    system "scons"
    include.install Dir["install/**/**/release/include/*"]
    lib.install Dir["install/**/**/release/lib/*"]
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

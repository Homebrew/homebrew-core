class Field3d < Formula
  desc "Library for storing voxel data on disk and in memory"
  homepage "https://sites.google.com/site/field3d/"
  url "https://github.com/imageworks/Field3D/archive/v1.7.2.tar.gz"
  sha256 "8f7c33ecb4489ed626455cf3998d911a079b4f137f86814d9c37c5765bf4b020"
  revision 7

  bottle do
    cellar :any
    sha256 "d69f93fd0267a8c4f5c5075b084a693920d1fb501ac94cc7befc501b34ff00e8" => :mojave
    sha256 "9b9781061c5162e9c8c8ae114a6819132adedd8b0ff3d7a0e0d46356a5954a61" => :high_sierra
    sha256 "7cdff726ef6ec08105a0bf3b8c08468ce15c48f7d0a383fee03b171be9d6d74a" => :sierra
    sha256 "2222a736747101ec9226b71524943bfe3c304913c0078dfc6a22bb0be434f9b5" => :el_capitan
  end

  depends_on "scons" => :build
  depends_on "boost"
  depends_on "hdf5"
  depends_on "ilmbase"

  def install
    scons
    include.install Dir["install/**/**/release/include/*"]
    lib.install Dir["install/**/**/release/lib/*"]
    man1.install "man/f3dinfo.1"
    pkgshare.install "contrib", "test", "apps/sample_code"
  end

  test do
    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lField3D",
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

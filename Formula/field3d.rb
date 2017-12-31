class Field3d < Formula
  desc "Library for storing voxel data on disk and in memory"
  homepage "https://sites.google.com/site/field3d/"
  url "https://github.com/imageworks/Field3D/archive/v1.7.2.tar.gz"
  sha256 "8f7c33ecb4489ed626455cf3998d911a079b4f137f86814d9c37c5765bf4b020"
  revision 4

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

class Field3d < Formula
  desc "Library for storing voxel data on disk and in memory"
  homepage "https://sites.google.com/site/field3d/"
  url "https://github.com/imageworks/Field3D/archive/v1.7.2.tar.gz"
  sha256 "8f7c33ecb4489ed626455cf3998d911a079b4f137f86814d9c37c5765bf4b020"
  revision 8

  bottle do
    cellar :any
    sha256 "05461715cbad0d1db99f9bda36761902fe61a87f5c666cb6caa98afb2d3bf1e0" => :mojave
    sha256 "defc2459a3a5cfcfc68ed7c9d7be62f41c56a30c4ea5626b9b7904a091e6a82a" => :high_sierra
    sha256 "b379c7580a6954d1130b294a5b4478f59750cb6f28aea3dcf868f31dc9c524a0" => :sierra
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

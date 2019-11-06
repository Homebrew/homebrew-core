class Field3d < Formula
  desc "Library for storing voxel data on disk and in memory"
  homepage "https://sites.google.com/site/field3d/"
  url "https://github.com/imageworks/Field3D/archive/v1.7.2.tar.gz"
  sha256 "8f7c33ecb4489ed626455cf3998d911a079b4f137f86814d9c37c5765bf4b020"
  revision 9

  bottle do
    cellar :any
    sha256 "e9bc286abc81f4d9e9a548d12052cb5983f97be7c71ba48fea596ca20a6299a3" => :catalina
    sha256 "5a309ce2f4638c73a6de3739bdfebcf95d1dc58b35ea3e788a7fd2aef86202c5" => :mojave
    sha256 "46dd1e449ac494a9fe2b16eee139915151aee504293492120b2d1bf4b8a74490" => :high_sierra
    sha256 "59d48d1f4975d7f86214169f3dad2c0fa5bfc3168ce659275518ff5c48504f9f" => :sierra
  end

  depends_on "scons" => :build
  depends_on "boost"
  depends_on "hdf5"
  depends_on "ilmbase"

  def install
    system "scons"
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

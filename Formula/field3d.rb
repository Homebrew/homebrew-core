class Field3d < Formula
  desc "Library for storing voxel data on disk and in memory"
  homepage "https://sites.google.com/site/field3d/"
  url "https://github.com/imageworks/Field3D/archive/v1.7.2.tar.gz"
  sha256 "8f7c33ecb4489ed626455cf3998d911a079b4f137f86814d9c37c5765bf4b020"
  revision 8

  bottle do
    cellar :any
    rebuild 1
    sha256 "ff0b5eaa63c128804ad506815ad75cd8f00802e3b49559a2648ca287258b3c69" => :mojave
    sha256 "0ab023753147454fd312ec1bb4bb91a93a0c6bfa9d011cd4b8eef443e845b72a" => :high_sierra
    sha256 "a96a703001b6b189bb90f98bb11ec2bf1a4fec4c72eeb2f7dba4785da5d7fede" => :sierra
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

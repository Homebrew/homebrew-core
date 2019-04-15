class Openvdb < Formula
  desc "Sparse volume processing toolkit"
  homepage "https://www.openvdb.org/"
  url "https://github.com/AcademySoftwareFoundation/openvdb/archive/v6.0.0.tar.gz"
  sha256 "dbdf3048336444c402e5d3727c9bfb2e84454b8d0fd468ba92a8c7225e24b7b4"
  revision 2
  head "https://github.com/AcademySoftwareFoundation/openvdb.git"

  bottle do
    sha256 "25c6873c89871ee1200bf7fdc594f5a49d93a7a9e4e3ce5d53dc3bbea690a1a1" => :mojave
    sha256 "1e61d2ab95f4cab9bf2bf7dc77ffae151b585fe982b5122bbd314ceba1cf13bd" => :high_sierra
    sha256 "356f08b2d1ad0b157a7e408641a72cab3aed98adc00539c1c6a8aa7eed38a905" => :sierra
  end

  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "c-blosc"
  depends_on "glfw"
  depends_on "ilmbase"
  depends_on "jemalloc"
  depends_on "openexr"
  depends_on "tbb"

  resource "test_file" do
    url "https://nexus.aswf.io/content/repositories/releases/io/aswf/openvdb/models/cube.vdb/1.0.0/cube.vdb-1.0.0.zip"
    sha256 "05476e84e91c0214ad7593850e6e7c28f777aa4ff0a1d88d91168a7dd050f922"
  end

  def install
    ENV.cxx11
    # Adjust hard coded paths in Makefile
    args = [
      "DESTDIR=#{prefix}",
      "BLOSC_INCL_DIR=#{Formula["c-blosc"].opt_include}",
      "BLOSC_LIB_DIR=#{Formula["c-blosc"].opt_lib}",
      "BOOST_INCL_DIR=#{Formula["boost"].opt_include}",
      "BOOST_LIB_DIR=#{Formula["boost"].opt_lib}",
      "BOOST_THREAD_LIB=-lboost_thread-mt",
      "CONCURRENT_MALLOC_LIB_DIR=#{Formula["jemalloc"].opt_lib}",
      "CPPUNIT_INCL_DIR=", # Do not use cppunit
      "CPPUNIT_LIB_DIR=",
      "DOXYGEN=doxygen",
      "EXR_INCL_DIR=#{Formula["openexr"].opt_include}/OpenEXR",
      "EXR_LIB_DIR=#{Formula["openexr"].opt_lib}",
      "LOG4CPLUS_INCL_DIR=", # Do not use log4cplus
      "LOG4CPLUS_LIB_DIR=",
      "NUMPY_INCL_DIR=",
      "PYTHON_VERSION=",
      "TBB_INCL_DIR=#{Formula["tbb"].opt_include}",
      "TBB_LIB_DIR=#{Formula["tbb"].opt_lib}",
      "GLFW_INCL_DIR=#{Formula["glfw"].opt_include}",
      "GLFW_LIB_DIR=#{Formula["glfw"].opt_lib}",
      "GLFW_LIB=-lglfw",
    ]

    ENV.append_to_cflags "-I #{buildpath}"

    cd "openvdb" do
      system "make", "install", *args
    end
  end

  test do
    resource("test_file").stage testpath
    system "#{bin}/vdb_print", "-m", "cube.vdb"
  end
end

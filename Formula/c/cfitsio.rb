class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio-4.6.0.tar.gz"
  sha256 "7c372fdb4e6cf530fc12294ae0b7f1fdd0ed85062790277a60aea56c97b0d3e7"
  license "CFITSIO"

  livecheck do
    url :homepage
    regex(/href=.*?cfitsio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0a2282e52cea1554ded11bf20b8ccb08c4797b841cbd2cab36a630060039d384"
    sha256 cellar: :any,                 arm64_sonoma:  "a34fdd4b5953b49582eaaf3096640c9b1125fa5efc7654996d8c0efddb6c4089"
    sha256 cellar: :any,                 arm64_ventura: "6518ed062c9fbdad59543f94dfc3e0075c408f9630f70f43c09ec49c5a3a2648"
    sha256 cellar: :any,                 sonoma:        "5dfcb63aace71db6811b9ef614bc4e96e739f09c6359addaa2f357097c9c7035"
    sha256 cellar: :any,                 ventura:       "e49c70a730a4e19450da1d7f370ea5f016acb3274544332b54195fa9d7c2a4b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5678b462c9945c96b60dd7359e2bdf4e9c74aecdc17d5f85cb96f56af0dbe3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76ab7cd815f1ef133e79644620f101acc45e236a6e2d9857f6af1a00518af6e2"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  uses_from_macos "zlib"

  def install
    # Incorporates upstream commits:
    #   https://github.com/HEASARC/cfitsio/commit/8ea4846049ba89e5ace4cc03d7118e8b86490a7e
    #   https://github.com/HEASARC/cfitsio/commit/6aee9403917f8564d733938a6baa21b9695da442
    # Review for removal in next release
    inreplace "cfitsio.pc.cmake" do |f|
      f.sub!(/exec_prefix=.*/, "exec_prefix=${prefix}")
      f.sub!(/libdir=.*/, "libdir=${exec_prefix}/@CMAKE_INSTALL_LIBDIR@")
      f.sub!(/includedir=.*/, "includedir=${prefix}/@CMAKE_INSTALL_INCLUDEDIR@")
    end

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_INSTALL_INCLUDEDIR=include
      -DUSE_PTHREADS=ON
      -DTESTS=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (pkgshare/"testprog").install Dir["testprog*", "utilities/testprog.c"]
  end

  test do
    cp Dir["#{pkgshare}/testprog/testprog*"], testpath
    flags = shell_output("pkg-config --cflags --libs #{name}").split
    system ENV.cc, "testprog.c", "-o", "testprog", *flags
    system "./testprog > testprog.lis"
    cmp "testprog.lis", "testprog.out"
    cmp "testprog.fit", "testprog.std"
  end
end

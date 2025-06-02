class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio-4.6.2.tar.gz"
  sha256 "66fd078cc0bea896b0d44b120d46d6805421a5361d3a5ad84d9f397b1b5de2cb"
  license "CFITSIO"

  livecheck do
    url :homepage
    regex(/href=.*?cfitsio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5211e3ed2c5d20c27a80a1a60392a0a40ba1124795fcb9a8969dbfc536bf75cc"
    sha256 cellar: :any,                 arm64_sonoma:  "99f6c0c152eed90cfc797714394de1428abc1e5bc056699bc9f227124fe537e1"
    sha256 cellar: :any,                 arm64_ventura: "8b92cc30cc355bb0522c74bd91481fedb21e31867812475e867fcb704b1336f6"
    sha256 cellar: :any,                 sonoma:        "95f8da6e88ef0f411fd4f0769e0ac1651a98760d02ea70e8f3e5df97c2f645e9"
    sha256 cellar: :any,                 ventura:       "65fb50a8957f974a68ced585b4742f42bc7684d80035499362571d425ccc6edd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9cfb371e8d8f3a17bbed2f50db40636c85bc22012725cd8f9a680474fba16e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5028bfb3c616cfec720d946007f9fe30f0284ad7b348800acb7d8cb9d516cffb"
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

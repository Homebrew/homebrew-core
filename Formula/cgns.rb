class Cgns < Formula
  desc "CFD General Notation System"
  homepage "http://cgns.org/"
  url "https://github.com/CGNS/CGNS/archive/v4.3.0.tar.gz"
  sha256 "7709eb7d99731dea0dd1eff183f109eaef8d9556624e3fbc34dc5177afc0a032"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/CGNS/CGNS.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "220b0b66c2cdbeac7c2d2d3b8ff2e23d46a1fa826446986f64fadd31fa3bebfb"
    sha256 cellar: :any,                 arm64_big_sur:  "4ece3d88556925498dc79351825510989c410aeb8e9ea6a074de6d71cd7da984"
    sha256 cellar: :any,                 monterey:       "05be0fed7e6fdc77a4b7c08df4242d8b8a3c581169f3dfb75ff94dce34e86340"
    sha256 cellar: :any,                 big_sur:        "82045a913f0430bba0c2dc4f02a5cf1232a104de428541a86b55d3627e957960"
    sha256 cellar: :any,                 catalina:       "f0ff9cb4346d5cae443c9d8e59348e42e8e3c07d6c0a0bb6deceab98288df004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc1c421bb922efb94b929a4fb24329de0a059392cfcc2066d5008c16dc765c53"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "hdf5"
  depends_on "libaec"

  uses_from_macos "zlib"

  def install
    args = %w[
      -DCGNS_ENABLE_64BIT=YES
      -DCGNS_ENABLE_FORTRAN=YES
      -DCGNS_ENABLE_HDF5=YES
    ]

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Avoid references to Homebrew shims
    inreplace include/"cgnsBuild.defs", Superenv.shims_path/ENV.cc, ENV.cc
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include "cgnslib.h"
      int main(int argc, char *argv[])
      {
        int filetype = CG_FILE_NONE;
        if (cg_is_cgns(argv[0], &filetype) != CG_ERROR)
          return 1;
        return 0;
      }
    EOS
    flags = %W[-L#{lib} -lcgns]
    flags << "-Wl,-rpath,#{lib},-rpath,#{Formula["libaec"].opt_lib}" if OS.linux?
    system Formula["hdf5"].opt_prefix/"bin/h5cc", "test.c", *flags
    system "./a.out"
  end
end

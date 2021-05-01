class Cgns < Formula
  desc "CFD General Notation System"
  homepage "http://cgns.org/"
  url "https://github.com/CGNS/CGNS/archive/v4.2.0.tar.gz"
  sha256 "090ec6cb0916d90c16790183fc7c2bd2bd7e9a5e3764b36c8196ba37bf1dc817"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/CGNS/CGNS.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "f9567a6308f239dd3d6d705caea7481e6e5d07a00c00f4b4d2afe210bb423865"
    sha256 big_sur:       "eeaaba2013f485bd7bdc9e229143c548b0116a6f9875f7b51994c137bcefb504"
    sha256 catalina:      "a9fe78346df744b791501adcc4e056d637614919f149da1c70190e216825df12"
    sha256 mojave:        "3be7b41175c8a5187b3eb20b4082b0987081e4b4848ee692e9093ece232ac344"
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "hdf5"
  depends_on "szip"

  uses_from_macos "zlib"

  def install
    args = std_cmake_args + %w[
      -DCGNS_ENABLE_64BIT=YES
      -DCGNS_ENABLE_FORTRAN=YES
      -DCGNS_ENABLE_HDF5=YES
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end

    # Avoid references to Homebrew shims
    inreplace include/"cgnsBuild.defs", HOMEBREW_LIBRARY/"Homebrew/shims/mac/super/clang", "/usr/bin/clang"
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
    system Formula["hdf5"].opt_prefix/"bin/h5cc", testpath/"test.c", "-L#{opt_lib}", "-lcgns"
    system "./a.out"
  end
end

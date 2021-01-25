class Cgns < Formula
  desc "CFD General Notation System"
  homepage "http://cgns.org/"
  url "https://github.com/CGNS/CGNS/archive/v4.1.2.tar.gz"
  sha256 "951653956f509b8a64040f1440c77f5ee0e6e2bf0a9eef1248d370f60a400050"
  license "BSD-3-Clause"
  head "https://github.com/CGNS/CGNS.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "e2e5eb665f0f5c94c7782f0aed3708124705792ff5a7adf945a537369db6d724" => :big_sur
    sha256 "abc3326bddbf58509b5ffb3834d68836ad803abf83f9958ae6a012870e7e9f85" => :arm64_big_sur
    sha256 "4371c695cad1aa0bccbaaf0deccb9a8f5ddf7271dcbbddf6307b8d0bc254cec5" => :catalina
    sha256 "d9904ca7c839a5d0421b99ba784e98fec047971de47efa5d3cc00725cd892e26" => :mojave
    sha256 "8bfeb33c22f79c998b31fea6aafc60aecf2edf18ea754799c67c012d90555ec9" => :high_sierra
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

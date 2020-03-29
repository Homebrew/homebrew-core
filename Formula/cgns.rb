class Cgns < Formula
  desc "CFD General Notation System"
  homepage "http://cgns.org/"
  url "https://github.com/CGNS/CGNS/archive/v4.1.1.tar.gz"
  sha256 "055d345c3569df3ae832fb2611cd7e0bc61d56da41b2be1533407e949581e226"

  bottle do
    cellar :any
    sha256 "58d72a07332c405794ad894f3660915603cf68a0a113c2ef7a53be90ddbb1c45" => :catalina
    sha256 "3061b10281a14b48f51e896acafb793cd2f6acbf2881a260a22a0dfcf3d83cf2" => :mojave
    sha256 "d7a8544d2c0c29019874097d8f70cdc68e46e5f635201130f91020d1b0af73a0" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "hdf5"
  depends_on "szip"

  uses_from_macos "zlib"

  def install
    args = std_cmake_args
    args << "-DCGNS_ENABLE_64BIT=YES" if Hardware::CPU.is_64_bit?
    args << "-DCGNS_ENABLE_FORTRAN=YES"
    args << "-DCGNS_ENABLE_HDF5=YES"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
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

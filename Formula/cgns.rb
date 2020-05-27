class Cgns < Formula
  desc "CFD General Notation System"
  homepage "http://cgns.org/"
  url "https://github.com/CGNS/CGNS/archive/v4.1.1.tar.gz"
  sha256 "055d345c3569df3ae832fb2611cd7e0bc61d56da41b2be1533407e949581e226"
  revision 1

  bottle do
    cellar :any
    sha256 "bd68e99330428811196cf3ed189ea61b67d86a2e58af3f0971b6d5f20f1d8ec4" => :catalina
    sha256 "f2f5d0c81b8adfcd2ef8d1a91c9b29f8e875fe6349badcac81e7e475caa4df89" => :mojave
    sha256 "d81da89ddc8f36b947f476362e60be07f7b5c81c209b4dfa960a26b007d9d1c8" => :high_sierra
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

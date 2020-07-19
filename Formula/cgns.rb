class Cgns < Formula
  desc "CFD General Notation System"
  homepage "http://cgns.org/"
  url "https://github.com/CGNS/CGNS/archive/v4.1.1.tar.gz"
  sha256 "055d345c3569df3ae832fb2611cd7e0bc61d56da41b2be1533407e949581e226"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/CGNS/CGNS.git"

  bottle do
    cellar :any
    sha256 "ac5ed0dcdfd12f7e07c483d355b26d46f8380cfadb069b60d7bee21c12f6d31a" => :catalina
    sha256 "e9bcc9d1af96b8ebc5ecb0d5ba16165edf750f75e53b6b81997bb5078b718c68" => :mojave
    sha256 "cd64974956ac61d5574db91ceba7bcf99e17981be478864ef7b368340e993025" => :high_sierra
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

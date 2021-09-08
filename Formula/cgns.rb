class Cgns < Formula
  desc "CFD General Notation System"
  homepage "http://cgns.org/"
  url "https://github.com/CGNS/CGNS/archive/v4.2.0.tar.gz"
  sha256 "090ec6cb0916d90c16790183fc7c2bd2bd7e9a5e3764b36c8196ba37bf1dc817"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/CGNS/CGNS.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "990a1aa3109f6738e6f35317bbbea723281d1c1ac4ca79ad59eee7c6e86f7ab2"
    sha256 big_sur:       "ea9d83f6f0d4385054814f42152993db58582e7acd5dbde4b667aa5c7242207d"
    sha256 catalina:      "517dfe99a307d2f4d96aa4931707596a6862bcd30b64a798375bcd7ec40cc232"
    sha256 mojave:        "ee6e9edeb0e1b7d7b630501dd2e76091354a05e0f31c2850ca2288ed159445ce"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
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
    system Formula["hdf5"].opt_prefix/"bin/h5cc", testpath/"test.c", "-L#{opt_lib}", "-lcgns"
    system "./a.out"
  end
end

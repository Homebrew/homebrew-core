class Cgns < Formula
  desc "CFD General Notation System"
  homepage "http://cgns.org/"
  url "https://github.com/CGNS/CGNS/archive/v4.3.0.tar.gz"
  sha256 "7709eb7d99731dea0dd1eff183f109eaef8d9556624e3fbc34dc5177afc0a032"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/CGNS/CGNS.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "03b714ec53de2f79deb450ea1609f8fa13454ceba9602d756096d0e1e70ca373"
    sha256 cellar: :any,                 arm64_monterey: "31c4c8fb55e1b0445f2a0bffd5891e88f76d103c91ce718ba7b13a5506ebc7ee"
    sha256 cellar: :any,                 arm64_big_sur:  "b40fb01503689516098100b3c493dee84cf3a182c6751d35778fd7e7f6067705"
    sha256 cellar: :any,                 ventura:        "9d9933171d051d02fedb804e2f4137a5525f62b86d9ae6ffd5c17a9b668e378e"
    sha256 cellar: :any,                 monterey:       "ef0306b868e4bdbe5884234dcadf93da65d0178d1b2cf9ecf5b85a3087efeb1d"
    sha256 cellar: :any,                 big_sur:        "c59cacfb19bd04311ea1296643e53badb53a6e8c4b355703743dd0cecfca9dc0"
    sha256 cellar: :any,                 catalina:       "32711a2b525fac2a509440ec5837ff0b4c68ca9d5e37400afd8bc628fe53f08b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb248e590f24966f13030464c284d71884c519ebb5da5cdd6f85a3658547e959"
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

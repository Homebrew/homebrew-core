class Cgns < Formula
  desc "CFD General Notation System"
  homepage "https://cgns.github.io/"
  url "https://github.com/CGNS/CGNS/archive/refs/tags/v4.5.0.tar.gz"
  sha256 "c72355219318755ba0a8646a8e56ee1c138cf909c1d738d258d2774fa4b529e9"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/CGNS/CGNS.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "b331f93f59e5f71811c11ec52ba9f1338688326246c98446191fe2444ef20294"
    sha256                               arm64_sequoia: "60d460320a92ecb06f0102b192002150f3822f71b0ca08afac1d0d2b2d7a03ee"
    sha256                               arm64_sonoma:  "059388e3ab976982dd8766d5331ee7c675d465199dadd0e51081332f739f5bcc"
    sha256                               arm64_ventura: "46b2bb044517369bba1c9dad5b820a3d4f9afeff452e662210d5dba46d1376f9"
    sha256                               sonoma:        "b0c10740cb9177010cf815816c1f31882d8ac61213022d68729dc2f3b65c43f2"
    sha256                               ventura:       "73cdae1cc580e91901eb1716e3c63fe55ed314a7f7855b9359f668b32151630b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5febb80e3e67c84e95a514afb3f9c084b5efa0f74290b74a49c48a69cedacec6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc3307b328259a4c034e3a8a14c4bae802f8a3d054858f2abb2f942a0e8927ed"
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
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include "cgnslib.h"
      int main(int argc, char *argv[])
      {
        int filetype = CG_FILE_NONE;
        if (cg_is_cgns(argv[0], &filetype) != CG_ERROR)
          return 1;
        return 0;
      }
    C
    flags = %W[-L#{lib} -lcgns]
    flags << "-Wl,-rpath,#{lib},-rpath,#{Formula["libaec"].opt_lib}" if OS.linux?
    system Formula["hdf5"].opt_prefix/"bin/h5cc", "test.c", *flags
    system "./a.out"
  end
end

class Cgns < Formula
  desc "CFD General Notation System"
  homepage "http://cgns.org/"
  url "https://github.com/CGNS/CGNS/archive/refs/tags/v4.4.0.tar.gz"
  sha256 "3b0615d1e6b566aa8772616ba5fd9ca4eca1a600720e36eadd914be348925fe2"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/CGNS/CGNS.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b2e3755ab8b84f161b0429ebbb0b73b4296ce0d92e8e722505e30a72c8c4d506"
    sha256 cellar: :any,                 arm64_sonoma:  "6d1f0bc2e232b02b4ffb5c439f7a020cc6a5b171814e0930dc66d605581516a9"
    sha256 cellar: :any,                 arm64_ventura: "f9366047e49d3e96d73726a0bf7ddfd136ac0c132a92fd64071faf50c6b3f6ca"
    sha256 cellar: :any,                 sonoma:        "beb81ecf8a4db4098991e474e79fac6029ffdb431034bc1bf8b17b7799dffd7d"
    sha256 cellar: :any,                 ventura:       "e7581a769881c706fd9abffeaa3319aaadd41501c440c3ab02f0ae6e4c311fa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3405dd84d98233abbd29df9dd28f948a7cf67daea4ad573d907d612aa49a7961"
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

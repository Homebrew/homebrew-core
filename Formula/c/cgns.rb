class Cgns < Formula
  desc "CFD General Notation System"
  homepage "https://cgns.github.io/"
  url "https://github.com/CGNS/CGNS/archive/refs/tags/v4.5.1.tar.gz"
  sha256 "ae63b0098764803dd42b7b2a6487cbfb3c0ae7b22eb01a2570dbce49316ad279"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/CGNS/CGNS.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "274b220aacb028fec11a4f272d7b24461431a7b7b00b19b4446a3cb097044b6a"
    sha256                               arm64_sequoia: "655fca22fe9c033af766b7d849e760aa9ff7b38bfa73234ed286fb553a021b4d"
    sha256                               arm64_sonoma:  "c807458cd9027b7151c53a27bae5c57b3bfe3cd8555e0001fec20fa1be82c995"
    sha256                               sonoma:        "b5608db10d3e167bbecb376532a8ce96d1a5e5d3dcff72f0dab2a74ac1b1e01f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d6f73711962658578e623e3eb4351027eee086086aebec4e2232875d12f04af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5447f14d57dcd51381c2db73025529bb7eab9ac74c210b5ee6e45bf9a44f18a"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "hdf5"

  def install
    # CMake FortranCInterface_VERIFY fails with LTO on Linux due to different GCC and GFortran versions
    ENV.append "FFLAGS", "-fno-lto" if OS.linux?

    args = %w[
      -DCGNS_ENABLE_64BIT=YES
      -DCGNS_ENABLE_FORTRAN=YES
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

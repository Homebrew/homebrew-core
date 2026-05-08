class Cgns < Formula
  desc "CFD General Notation System"
  homepage "https://cgns.github.io/"
  url "https://github.com/CGNS/CGNS/archive/refs/tags/v4.5.2.tar.gz"
  sha256 "95075e1fd0b51d97b1b96b73ebe03b1a551fbcc9cd2b2b6f487ccccedcff5964"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://github.com/CGNS/CGNS.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "c8229b3a6b131912d7652140857ece7f0a44a190488c01ebc747d31f94e127c2"
    sha256                               arm64_sequoia: "e1d1bdba8c38e5099a1f8e2027a5856ec8eb8ccd0cb92fcb23f09d696f6eb73b"
    sha256                               arm64_sonoma:  "c2c6e7e1d6388b718e48607bdddb0603de381678962e5d37ac42fdc54a32d1de"
    sha256                               sonoma:        "71fa5029c484e5d8d390250e5c57d9bd0db745bf505b3395ae5234a1766f8431"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "843d70b36039426534c8a6f123f20284849718c92014a11d3c778cea68bf008e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cf25cd9e1e520b2fc26339c0b9c1de09df89cea53e9f8b3785fc3964be8ebe3"
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

class Cgns < Formula
  desc "CFD General Notation System"
  homepage "https://cgns.github.io/"
  url "https://github.com/CGNS/CGNS/archive/refs/tags/v4.5.1.tar.gz"
  sha256 "5da0e19907c1649a2f4b5d2abdb733674ae1a58d7436916a5fba1eb2f33f395f"
  license "BSD-3-Clause"
  head "https://github.com/CGNS/CGNS.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "c7f96718f36eb18d9a05381c313665a062617a603a5f716c53d93747e75a25d8"
    sha256                               arm64_sequoia: "9cc8f9ae5b023e4ec4e3f8dac4f82d0255ca6c7d767a718fc8e651e6bfaab07f"
    sha256                               arm64_sonoma:  "23ee5135084e419ee9faf9740f395a920a5016097ab79bcfe34bd27ee46786f1"
    sha256                               sonoma:        "7a0d3fbf1574d2351cb0a974084d9b84b6d675cb986bbeeb147583856c4721af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee020f9fef1fe98cddb5a3d01a5a3df51733b2623931cccb363c6e0f7723bcc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fad29163df664e319377262322630cced218cae72c5cecc9e72a2e831ca6dce"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "hdf5"

  def install
    # Use GCC matching gfortran to avoid ABI issues with Fortran interface on Linux
    ENV["CC"] = Formula["gcc"].opt_bin/"gcc-#{Formula["gcc"].version.major}" if OS.linux?

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

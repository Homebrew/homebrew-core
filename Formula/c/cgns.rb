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
    sha256 cellar: :any,                 arm64_sonoma:   "4a36e9f04e131b588140deb67750c17af4872194edfb6532465b1eb7cb6489ea"
    sha256 cellar: :any,                 arm64_ventura:  "ce99c50f036019874327c95a79a224a87360b6ed94253cff8efc405fd7bff096"
    sha256 cellar: :any,                 arm64_monterey: "d4cac694928a1107b7f78561babe8ad5997914f19663dff150e6c827c602d831"
    sha256 cellar: :any,                 arm64_big_sur:  "226385007cf78e02dbe88e56718c1662f0c26692a1a15eb502721427c82b9944"
    sha256 cellar: :any,                 sonoma:         "ce1583b6de0e9202d9e74119c2d8dfb5af07673f0b6fdd5ce3a37c9387e3bb98"
    sha256 cellar: :any,                 ventura:        "b8d92b3b67c9b85f9baf1779a70bc738d42f7cbb4586e6fc341689b1d61ee0ec"
    sha256 cellar: :any,                 monterey:       "8979f06f47c90538924a233349020b1358f6fab95d8cc2097aa56b2fc3ca1799"
    sha256 cellar: :any,                 big_sur:        "7bf1c37a0e5bbe6f9f3418b6eaaacb4ddb13e4c278438a9ca97c5bee428782a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d41b94fa8b9aa29224d83663f9a237ee18e793e8969c4b6193d2d03a200ed9e"
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

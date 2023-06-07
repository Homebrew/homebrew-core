class Cgns < Formula
  desc "CFD General Notation System"
  homepage "http://cgns.org/"
  url "https://github.com/CGNS/CGNS/archive/v4.3.0.tar.gz"
  sha256 "7709eb7d99731dea0dd1eff183f109eaef8d9556624e3fbc34dc5177afc0a032"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/CGNS/CGNS.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e89f0c5e4c482a3f4a7d54f4bfccd1e26d8732903c6c2b49cad59209ca41ea07"
    sha256 cellar: :any,                 arm64_monterey: "980de22eb6a5d617b6d60fbe2c4721f3f7ee45bb196b9a45c132359c5d6f2bfc"
    sha256 cellar: :any,                 arm64_big_sur:  "d2bd883fe42da5c0fe8c0a91813c0e42d32facd4c704b1142e31f8901fd35e80"
    sha256 cellar: :any,                 ventura:        "deabebfb6d36a78eedc3abb29e4b36887359195d1d125508d7dcd668e776dddc"
    sha256 cellar: :any,                 monterey:       "a2cfa80e681dd459ebbf98cd96735eb508d87a6bc30d8bbac4be53ec72665c77"
    sha256 cellar: :any,                 big_sur:        "2f555d17c91e508a0138e7979c53925ce26a2090b649dbb693db4af86dd311dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ec591d0c6a31cc3b91b798f2650ea19862fcb030e46d8682e199811665c7a9a"
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

class Cgns < Formula
  desc "CFD General Notation System"
  homepage "http://cgns.org/"
  url "https://github.com/CGNS/CGNS/archive/v4.3.0.tar.gz"
  sha256 "7709eb7d99731dea0dd1eff183f109eaef8d9556624e3fbc34dc5177afc0a032"
  license "BSD-3-Clause"
  head "https://github.com/CGNS/CGNS.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "057bb4d7e50bc286171fa587de69efb9ce454b7fe7ab6bff425b7c8368b5b010"
    sha256 cellar: :any, arm64_big_sur:  "db527fa7c0a2f0ead35df1392540897c71209d2a4bc1ea2e1cdb045a5d951ac3"
    sha256 cellar: :any, monterey:       "16bb4d982bc42a946eeea3190340d91948aeb264ea3f9a9279a86bae77e891bc"
    sha256 cellar: :any, big_sur:        "828170fcea5d6707fed2f5428c762ba57d75a36120bec5a4547543cc7df26995"
    sha256 cellar: :any, catalina:       "b47c62791fb05f0038d712448c93de085f0101fcbbf89bee19602422a36e3887"
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

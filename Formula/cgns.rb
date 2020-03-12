class Cgns < Formula
  desc "CFD General Notation System"
  homepage "http://cgns.org/"
  url "https://github.com/CGNS/CGNS/archive/v4.1.0.tar.gz"
  sha256 "4674de1fac3c47998248725fd670377be497f568312c5903d1bb8090a3cf4da0"

  bottle do
    cellar :any
    sha256 "793f64165c0a72514abc0ef026b57e0363ad3bf6dcf8cb6f235958ca2cd1627a" => :catalina
    sha256 "8489af04beb15919be9b7b1e81d1b3bee5393ccbd51e4712aa3e40aa113af8d8" => :mojave
    sha256 "4b95c53f1b492ec6cf4655f98423067a031eb3e114a9b39be2320efdaf5c29c2" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "hdf5"
  depends_on "szip"

  uses_from_macos "zlib"

  def install
    args = std_cmake_args
    args << "-DCGNS_ENABLE_64BIT=YES" if Hardware::CPU.is_64_bit?
    args << "-DCGNS_ENABLE_FORTRAN=YES"
    args << "-DCGNS_ENABLE_HDF5=YES"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
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
        printf(\"%d.%d.%d\\n\",CGNS_VERSION/1000,(CGNS_VERSION/100)%10,(CGNS_VERSION/10)%10);
        return 0;
      }
    EOS
    system Formula["hdf5"].opt_prefix/"bin/h5cc", testpath/"test.c", "-L#{opt_lib}", "-lcgns"
    assert_match(/#{version}/, shell_output("./a.out"))
  end
end

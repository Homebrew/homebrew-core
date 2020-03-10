class Cgns < Formula
  desc "CFD General Notation System"
  homepage "http://cgns.org/"
  url "https://github.com/CGNS/CGNS/archive/v4.1.0.tar.gz"
  sha256 "4674de1fac3c47998248725fd670377be497f568312c5903d1bb8090a3cf4da0"

  bottle do
    sha256 "a54d74618a6b9dc4c9e67345ff9dd0fe32cfcef012f66c407aef0c3bfa8995da" => :catalina
    sha256 "c529165fc8eb117dd0418ac66790c8668038bcce1795f4e3bd7a9de7f7a0fd25" => :mojave
    sha256 "a0a565088bce07a85abbefe786af293bc66ea7ed138c19bb35b4e128038e7bbf" => :high_sierra
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

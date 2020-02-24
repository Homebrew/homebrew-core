class Cgns < Formula
  desc "CFD General Notation System"
  homepage "http://cgns.org/"
  url "https://github.com/CGNS/CGNS/archive/v3.4.0.tar.gz"
  sha256 "6372196caf25b27d38cf6f056258cb0bdd45757f49d9c59372b6dbbddb1e05da"

  bottle do
    sha256 "0ca1705629f5c38e41c5ad47f5855f970c57d146562d869f31d549cf2d2bf56f" => :catalina
    sha256 "4cc212cbc9216a3611418f406c3e83d5285d8cb42585bff92305c3e8fc75874a" => :mojave
    sha256 "57ab3d97cbc7267236e557e310c2232028dfd3980716e04ee25dc59673a2031a" => :high_sierra
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

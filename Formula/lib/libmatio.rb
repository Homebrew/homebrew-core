class Libmatio < Formula
  desc "C library for reading and writing MATLAB MAT files"
  homepage "https://matio.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/matio/matio/1.5.27/matio-1.5.27.tar.gz"
  sha256 "0a6aa00b18c4512b63a8d27906b079c8c6ed41d4b2844f7a4ae598e18d22d3b3"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "12a723da0082d255f8061cee5512636fbbda001bf3d7fc9b104b707f36898c31"
    sha256 cellar: :any,                 arm64_ventura:  "19d3701ee1d0070997c54c3a52e5e909603f52c9ab0a9e938ea7cf194cd003d8"
    sha256 cellar: :any,                 arm64_monterey: "75ae243a0b2a566a6d6d3988cf3e773749aae9330348d0e9006acee1311baf39"
    sha256 cellar: :any,                 sonoma:         "874958e993f5f822d0daec8b96dfcc1ced8cddacc3be282ec37d3cc708578be6"
    sha256 cellar: :any,                 ventura:        "9217e3824e9362d77369caf48248d9bb4d7195f076a8330f58bac8e30c7f538b"
    sha256 cellar: :any,                 monterey:       "7787bc49255f84702ef1c07d318521962d3d136eac128c714bf96b18599e7784"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7991c3e1a4419ef357741d862a946098a17048097f42e4648bb06bf59005f4e9"
  end

  depends_on "pkg-config" => :test
  depends_on "hdf5"
  uses_from_macos "zlib"

  # fix pkg-config linkage for hdf5 and zlib
  patch :DATA

  def install
    args = %W[
      --enable-extended-sparse=yes
      --enable-mat73=yes
      --with-hdf5=#{Formula["hdf5"].opt_prefix}
    ]
    args << "--with-zlib=#{Formula["zlib"].opt_prefix}" unless OS.mac?

    system "./configure", *std_configure_args, *args
    system "make", "install"
  end

  test do
    resource "homebrew-test_mat_file" do
      url "https://web.uvic.ca/~monahana/eos225/poc_data.mat.sfx"
      sha256 "a29df222605476dcfa660597a7805176d7cb6e6c60413a3e487b62b6dbf8e6fe"
    end

    testpath.install resource("homebrew-test_mat_file")
    (testpath/"mat.c").write <<~EOS
      #include <stdlib.h>
      #include <matio.h>

      size_t dims[2] = {5, 5};
      double data[25] = {0.0, };
      mat_t *mat;
      matvar_t *matvar;

      int main(int argc, char **argv) {
        if (!(mat = Mat_Open(argv[1], MAT_ACC_RDONLY)))
          abort();
        Mat_Close(mat);

        mat = Mat_CreateVer("test_writenan.mat", NULL, MAT_FT_DEFAULT);
        if (mat) {
          matvar = Mat_VarCreate("foo", MAT_C_DOUBLE, MAT_T_DOUBLE, 2,
                                 dims, data, MAT_F_DONT_COPY_DATA);
          Mat_VarWrite(mat, matvar, MAT_COMPRESSION_NONE);
          Mat_VarFree(matvar);
          Mat_Close(mat);
        } else {
          abort();
        }
        mat = Mat_CreateVer("foo", NULL, MAT_FT_MAT73);
        return EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "mat.c", "-o", "mat", "-I#{include}", "-L#{lib}", "-lmatio"
    system "./mat", "poc_data.mat.sfx"

    refute_includes shell_output("pkg-config --cflags matio"), "-I/usr/include"
  end
end

__END__
diff --git a/matio.pc.in b/matio.pc.in
index 96d9402..139f11e 100644
--- a/matio.pc.in
+++ b/matio.pc.in
@@ -6,6 +6,5 @@ includedir=@includedir@
 Name: MATIO
 Description: MATIO Library
 Version: @VERSION@
-Libs: -L${libdir} -lmatio
-Cflags: -I${includedir}
-Requires.private: @HDF5_REQUIRES_PRIVATE@ @ZLIB_REQUIRES_PRIVATE@
+Libs: -L${libdir} -lmatio @HDF5_LIBS@ @ZLIB_LIBS@
+Cflags: -I${includedir} @HDF5_CFLAGS@ @ZLIB_CFLAGS@

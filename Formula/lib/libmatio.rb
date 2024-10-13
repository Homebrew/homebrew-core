class Libmatio < Formula
  desc "C library for reading and writing MATLAB MAT files"
  homepage "https://matio.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/matio/matio/1.5.27/matio-1.5.27.tar.gz"
  sha256 "0a6aa00b18c4512b63a8d27906b079c8c6ed41d4b2844f7a4ae598e18d22d3b3"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7bfbaa9c2de6d92700c10352d5558bc10e1257ea31cfe20a3b595ad7f16d3c51"
    sha256 cellar: :any,                 arm64_sonoma:  "e4b7ba02b711df4335d9086e72cb20668fc1d353cac2d21f2d4958de980e1f2c"
    sha256 cellar: :any,                 arm64_ventura: "288e89283a9015d9d60d590f182e6a702bbf08b799b063b0e028a66c756955cb"
    sha256 cellar: :any,                 sonoma:        "6448a61dcaa62861d5c9577f2107a1df81a796f5e70dea9da803799456c91773"
    sha256 cellar: :any,                 ventura:       "39385330a5ad873eadb670181cce882cfd56ff62e541382adcb43636a6926252"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34f93f1a1b59dff1ca2a03c5ce0cbe6bdd73452661917fa16641d0311187f7f7"
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

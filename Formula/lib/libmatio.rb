class Libmatio < Formula
  desc "C library for reading and writing MATLAB MAT files"
  homepage "https://matio.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/matio/matio/1.5.30/matio-1.5.30.tar.gz"
  sha256 "8bd3b9477042ecc00dd71c04762fa58468e14cccc32fd8c6826c2da1e8bc3107"
  license "BSD-2-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "9ca72d65bf5da29bddfbe606984e69151d6e26744783b2893a34e9318e7ae22c"
    sha256 cellar: :any,                 arm64_sequoia: "7f5745b00f477b3aa6544162e3bb0ae280898c04041f3b1350bfc507638f040e"
    sha256 cellar: :any,                 arm64_sonoma:  "047c7d990b169c3ba1215246b4db54cd8ff33b7a194c67e8060aa7ce62c66486"
    sha256 cellar: :any,                 sonoma:        "83734b9696e4075b6bb93b5759a39f61195f01fa915879912d2622489813d2af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96ccac4352f0a05a8b17132ffd0ea5f0d6fa9fc26f0f7512c0e3b85616eaf8d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75875bd017f8e01b60e5bf97fc8140440e0dcaa018c4e2d7809f20b31cfd3071"
  end

  depends_on "pkgconf" => :test
  depends_on "hdf5"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # fix pkg-config linkage for hdf5 and zlib
  patch :DATA

  def install
    args = %W[
      --enable-extended-sparse=yes
      --enable-mat73=yes
      --with-hdf5=#{Formula["hdf5"].opt_prefix}
    ]
    args << "--with-zlib=#{Formula["zlib-ng-compat"].opt_prefix}" unless OS.mac?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    resource "homebrew-test_mat_file" do
      url "https://web.uvic.ca/~monahana/eos225/poc_data.mat.sfx"
      sha256 "a29df222605476dcfa660597a7805176d7cb6e6c60413a3e487b62b6dbf8e6fe"
    end

    testpath.install resource("homebrew-test_mat_file")
    (testpath/"mat.c").write <<~C
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
    C
    system ENV.cc, "mat.c", "-o", "mat", "-I#{include}", "-L#{lib}", "-lmatio"
    system "./mat", "poc_data.mat.sfx"

    refute_includes "-I/usr/include", shell_output("pkgconf --cflags matio")
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

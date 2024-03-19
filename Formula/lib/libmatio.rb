class Libmatio < Formula
  desc "C library for reading and writing MATLAB MAT files"
  homepage "https://matio.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/matio/matio/1.5.26/matio-1.5.26.tar.gz"
  sha256 "8b47c29f58e468dba7a5555371c6a72ad4c6aa8b15f459b2b0b65a303c063933"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "13567c415371bc87b4cacd46de35b3ea36e618b685cdd42b3e1a1a0f90f4d22c"
    sha256 cellar: :any,                 arm64_ventura:  "f72d1bb3e55e5236c5979b510043d38d7ab9313d0f4c110a3368adacda73f84f"
    sha256 cellar: :any,                 arm64_monterey: "c59978c8734ff5373f244225e075e1efcc4b6e2c84cde84aa4bab99eebcae088"
    sha256 cellar: :any,                 sonoma:         "f4c170f116b9ceb3ab4427188fb90e28576b9afbdef20916ebd3d3f7071dd196"
    sha256 cellar: :any,                 ventura:        "85eb3ad8aaba3cb495dd884c05f214b04f5262c72029fa11ad17d766b369c42b"
    sha256 cellar: :any,                 monterey:       "c854ec0a1d8ede9ab13b15dbf08126032af050e5d295b5e32c77493f7f62ae09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fa36654b9df0d1949829c67c19ca11f7a6f7873c2218617c9f936f2abbc32f5"
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

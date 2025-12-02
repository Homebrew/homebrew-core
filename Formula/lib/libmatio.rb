class Libmatio < Formula
  desc "C library for reading and writing MATLAB MAT files"
  homepage "https://matio.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/matio/matio/1.5.29/matio-1.5.29.tar.gz"
  sha256 "d9e5f7a2f2c594eff15f550e34729b01991cdd5a028a558be8ce595b32233afb"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ae99fcdca7044ba6a6bd70bcde020ce8d1cb40c928f29db562cba12660aca966"
    sha256 cellar: :any,                 arm64_sequoia: "aa29ffa6b398dd0e5ad2fc176b795ec89d5563af21b332923674f86340ef00f6"
    sha256 cellar: :any,                 arm64_sonoma:  "1977bb57f5fef8bcbb08be4a6d4c574a2e567b2d4fbcbc66b669b453c7092492"
    sha256 cellar: :any,                 sonoma:        "5f2884e960b11e3243aed0262c3c1650141b340d657fe9bb2372164d5843e6de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ec7706a6608b716870e9cc6cb8a228ad4fb0e223d66a0bf36d8eb58b5d75df3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "083925243e719c5d0c4f27c94fcebd14fe3717a7e8e25971364554f0dd0c1af4"
  end

  depends_on "pkgconf" => :test
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

class Libmatio < Formula
  desc "C library for reading and writing MATLAB MAT files"
  homepage "https://matio.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/matio/matio/1.5.21/matio-1.5.21.tar.gz"
  sha256 "21809177e55839e7c94dada744ee55c1dea7d757ddaab89605776d50122fb065"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "3782a120f0b6f6f7a4ed927623eb131720745c838fde6825e2c3af242b62638d"
    sha256 cellar: :any, big_sur:       "69052f804c792632ed2e29c4061015bb3c3270cbb6a6146f0959b5aa8f0133b8"
    sha256 cellar: :any, catalina:      "3be0157dbe335338b1adedb1a0dcd8ffca7695f6f4ecf09a84fcbc36662e0535"
    sha256 cellar: :any, mojave:        "ff7ed32d83439cd0e274468f44962509577146f511c0ac27eb9515cfc3a4b8c1"
  end

  depends_on "hdf5"

  resource "test_mat_file" do
    url "https://web.uvic.ca/~monahana/eos225/poc_data.mat.sfx"
    sha256 "a29df222605476dcfa660597a7805176d7cb6e6c60413a3e487b62b6dbf8e6fe"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-extended-sparse=yes
      --enable-mat73=yes
      --with-hdf5=#{Formula["hdf5"].opt_prefix}
      --with-zlib=/usr
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    testpath.install resource("test_mat_file")
    (testpath/"mat.c").write <<~'EOS'
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
  end
end

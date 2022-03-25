class Libmatio < Formula
  desc "C library for reading and writing MATLAB MAT files"
  homepage "https://matio.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/matio/matio/1.5.22/matio-1.5.22.tar.gz"
  sha256 "80c3d1e222e115768b57b7de640a37d0ee7cb7a3bd039db3ea941e71fc5204c3"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2543bb273ff8c2a4d36bd087a563c19bc99d7c709130544d5da7a8954b94c984"
    sha256 cellar: :any,                 arm64_big_sur:  "83535d794eb32470b1272bc210afe19ba21b10f4549eaa61b98d4bc172a89048"
    sha256 cellar: :any,                 monterey:       "fd77f8a1a2668e7fa341590738f31fa15729d18c0eb8d7348241843b380f2a8a"
    sha256 cellar: :any,                 big_sur:        "4015116bdbe565d268904594816a5e1eca9e1fccc3a61da1eff8b1e8911cc1dd"
    sha256 cellar: :any,                 catalina:       "fe8e1aecf04374a42029201cdd9d64da5554eb9548ff57b6bf96d4dc0ec79dac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1ce599ef49eb124309f42a69b3c179258e61b2a930ba0c8a3fd353171c7e40a"
  end

  depends_on "hdf5"

  resource "homebrew-test_mat_file" do
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
    testpath.install resource("homebrew-test_mat_file")
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

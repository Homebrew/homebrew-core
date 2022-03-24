class Libmatio < Formula
  desc "C library for reading and writing MATLAB MAT files"
  homepage "https://matio.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/matio/matio/1.5.22/matio-1.5.22.tar.gz"
  sha256 "80c3d1e222e115768b57b7de640a37d0ee7cb7a3bd039db3ea941e71fc5204c3"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3791b5964bfbf7fce08c52629b62ff302db1a037e65d58aba5e57dfea264d19e"
    sha256 cellar: :any,                 arm64_big_sur:  "ba06c58df165b0550cd8d9807ab66df831d2491aab1cacbd3ddba5ca07be5169"
    sha256 cellar: :any,                 monterey:       "d995f05ac10bbb93c564b4eb0434d2423971d4c742b32a2454b1d83af14c335d"
    sha256 cellar: :any,                 big_sur:        "3913f0461bbb1dfd96e1769e8ab2f47cca16e8c5f997ac4180db1d16dad11990"
    sha256 cellar: :any,                 catalina:       "cd51a4f4185607dc05fbf2c790f3481a8a6bc1fe1da5eda84c8209f4c851ec36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4053df10fe94a36caf42367e5484bfa4a29969f92f6d8b71b225784310224b2c"
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

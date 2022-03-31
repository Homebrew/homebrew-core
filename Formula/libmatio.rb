class Libmatio < Formula
  desc "C library for reading and writing MATLAB MAT files"
  homepage "https://matio.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/matio/matio/1.5.22/matio-1.5.22.tar.gz"
  sha256 "80c3d1e222e115768b57b7de640a37d0ee7cb7a3bd039db3ea941e71fc5204c3"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "24a8ecfe96e86e1949e2404a8973d1bc43a2d8c86aa014f0bfb0b7d137348adc"
    sha256 cellar: :any,                 arm64_big_sur:  "460be5d7a32ab867d1ee81628a76d02777615629b87eb18894e749c81ec5e105"
    sha256 cellar: :any,                 monterey:       "541e9c48ca5482f1cb56617994447994dfe084a2c9fb3ba1d227f3e4134c6207"
    sha256 cellar: :any,                 big_sur:        "168a296da2c49443171a5153aa9de40ef397d171dcd8a7770a8cb36afa6482d8"
    sha256 cellar: :any,                 catalina:       "ac4c00a118d4193c6bb1008e534db2bd81eed9efa3a1b9262849360cc8a31a42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23924d2738e02983f476e1500aa75833aeb2c421b006b10bb53c73e97bdb4918"
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

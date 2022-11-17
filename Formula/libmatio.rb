class Libmatio < Formula
  desc "C library for reading and writing MATLAB MAT files"
  homepage "https://matio.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/matio/matio/1.5.23/matio-1.5.23.tar.gz"
  sha256 "9f91eae661df46ea53c311a1b2dcff72051095b023c612d7cbfc09406c9f4d6e"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f054bccc0f7b6bb47c001f89bd71c3a506ea2826b4b175ecc4eca800013cc662"
    sha256 cellar: :any,                 arm64_monterey: "2ebdabd8423bbaeaa00d7083a52b83ff3fe2f0bcd451c2ed6594a75e5344eaa0"
    sha256 cellar: :any,                 arm64_big_sur:  "121e79cf19f53276b35be99b8f5ddf1922eac000a60005876d74039e63acf3c6"
    sha256 cellar: :any,                 ventura:        "ead0d4c1020d6a8650bc87e57c0782f99fe2e46625b9506e2035f5918303ff02"
    sha256 cellar: :any,                 monterey:       "065fdfe8c7d13dd17f2082ec55c02d4aa445c391ce3eaff3b5ff987f5a1f3f68"
    sha256 cellar: :any,                 big_sur:        "056c699084c0a29cf51cbc3a58cc5ae469501a27ccc7785773b260d0c2cbe09b"
    sha256 cellar: :any,                 catalina:       "4a5fb729796b011d5ee47e924d6b9c10084803d436c6234011f499c07b5d664f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90857721a7996319c0b57ed2c87bb7331f9c237a3b0a72a21d404493a83eca4a"
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

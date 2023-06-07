class Libmatio < Formula
  desc "C library for reading and writing MATLAB MAT files"
  homepage "https://matio.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/matio/matio/1.5.23/matio-1.5.23.tar.gz"
  sha256 "9f91eae661df46ea53c311a1b2dcff72051095b023c612d7cbfc09406c9f4d6e"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d4a44ba92a017b7f44ae69bd42cfafe09a04d20f47934a7ec201af2fa65d20e5"
    sha256 cellar: :any,                 arm64_monterey: "c6eb8fbcd5aee94c1ffb93fb393d4b27d6bce72f80876a6660b86c02c94c3049"
    sha256 cellar: :any,                 arm64_big_sur:  "5034eb49bfcc7c0a480e0f37d16877a9af2ead576f92c21e56b4ba5dbf2dc952"
    sha256 cellar: :any,                 ventura:        "18ad56b84938aaed596846c02f281ff107f8bf807effb0c8fa6075c43b1af9be"
    sha256 cellar: :any,                 monterey:       "3763f2836ab720551802912fcb5f54d9afbe50d8578883faa3c3484c142e39af"
    sha256 cellar: :any,                 big_sur:        "9e37c57537177229ecea33a3392b7c1c3799e3917ca2b5327fdbba3bb2818e00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97948be20c34c6b824647b45d7a301576a04b301b605164221e951e11a6f75f6"
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
  end
end

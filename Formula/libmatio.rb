class Libmatio < Formula
  desc "C library for reading and writing MATLAB MAT files"
  homepage "https://matio.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/matio/matio/1.5.19/matio-1.5.19.tar.gz"
  sha256 "a4fa4d248b0414fc72f3d6155f710c470d5628d3c31af834f8d5ccf06b60286f"
  license "BSD-2-Clause"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "6581c5cc3897753a78031740d10ccc534e9d0e8bde17d7c97d578b0b034d0475" => :big_sur
    sha256 "c2ce5f216e9fa77fd0d328504a4d339e1061b5e1c8800d7a1d741ac65c50a3ab" => :arm64_big_sur
    sha256 "ceb9363a18078ce2c25154d230a359ec3ce3db0cea9c2aaea3cfd41119806363" => :catalina
    sha256 "f015d539a7c798899a45b3a35d2795bc64aef3856b2ef5ef08fba6cf21295e25" => :mojave
    sha256 "41b16e1b850d33c612c474b2780b27396ba83da81f875a869014e5232d1f06da" => :high_sierra
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

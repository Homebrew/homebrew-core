class Libmatio < Formula
  desc "C library for reading and writing MATLAB MAT files"
  homepage "https://matio.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/matio/matio/1.5.23/matio-1.5.23.tar.gz"
  sha256 "9f91eae661df46ea53c311a1b2dcff72051095b023c612d7cbfc09406c9f4d6e"
  license "BSD-2-Clause"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "692ff91102a1882368444eaffb2b4134f25550f2792698d1fd36337f318e8465"
    sha256 cellar: :any,                 arm64_monterey: "779a488063e24d4d9ab188be23f94f53155d5014a478d55500ef27c26fb2911b"
    sha256 cellar: :any,                 arm64_big_sur:  "0a0c9260534dfe974fa4bd9ca28c26e321db5b2e36c53494c1e56a6f79c00ee4"
    sha256 cellar: :any,                 ventura:        "7b6ded7eaa0c7e18c0e4a3835a0bcfde53878416ac82d816adba21a622911d61"
    sha256 cellar: :any,                 monterey:       "e93c4b9479da91da21e25673bd9ca8f6d752cafd65c302fa37477e1ed6743465"
    sha256 cellar: :any,                 big_sur:        "b0d10fef3792de609e10b14720f5c632e4c179273de51de3da07a13d2ae7ae3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93c7c6f5e6fff8637b9e7fd5467057e1662546e7e44a00db08743f12eab6b838"
  end

  depends_on "pkg-config" => :test
  depends_on "hdf5"
  uses_from_macos "zlib"

  resource "homebrew-test_mat_file" do
    url "https://web.uvic.ca/~monahana/eos225/poc_data.mat.sfx"
    sha256 "a29df222605476dcfa660597a7805176d7cb6e6c60413a3e487b62b6dbf8e6fe"
  end

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

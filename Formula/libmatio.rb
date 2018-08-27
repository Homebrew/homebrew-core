class Libmatio < Formula
  desc "C library for reading and writing MATLAB MAT files"
  homepage "https://matio.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/matio/matio/1.5.12/matio-1.5.12.tar.gz"
  sha256 "8695e380e465056afa5b5e20128935afe7d50e03830f9f7778a72e1e1894d8a9"
  revision 2

  bottle do
    cellar :any
    sha256 "dc9a7e72e5871fe671c9a0864306115ec21384066f004cdf1d1fc3554f6b85f2" => :high_sierra
    sha256 "c66535a4ce314496c5dec2c968a0e84e4159859a21c7732f533ae145fc00f43b" => :sierra
    sha256 "965336caefe3d0db919e3e9a4d37e5c95df818c2d92f2a4af925822ded251299" => :el_capitan
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
      int main(int argc, char **argv) {
        mat_t *matfp;
        if (!(matfp = Mat_Open(argv[1], MAT_ACC_RDONLY)))
          abort();
        Mat_Close(matfp);
        return EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "mat.c", "-o", "mat", "-I#{include}", "-L#{lib}", "-lmatio"
    system "./mat", "poc_data.mat.sfx"
  end
end

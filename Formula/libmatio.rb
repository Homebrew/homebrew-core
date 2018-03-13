class Libmatio < Formula
  desc "C library for reading and writing MATLAB MAT files"
  homepage "https://matio.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/matio/matio/1.5.12/matio-1.5.12.tar.gz"
  sha256 "8695e380e465056afa5b5e20128935afe7d50e03830f9f7778a72e1e1894d8a9"

  bottle do
    cellar :any
    sha256 "43b0e6cfd7de1e3b7d2d8417a362c1959f95f591083c1324e1b4321a4dfbb87c" => :high_sierra
    sha256 "955dc30b86226f916b5634d2d1778df5ac2fedb7518f31d2bcf33dbda9807260" => :sierra
    sha256 "5b75630b6704777e1c66fc34c75b16fd887f8f59375fa1b53242279261f865d2" => :el_capitan
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

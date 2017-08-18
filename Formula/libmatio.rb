class Libmatio < Formula
  desc "C library for reading and writing MATLAB MAT files"
  homepage "https://matio.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/matio/matio/1.5.10/matio-1.5.10.tar.gz"
  sha256 "41209918cebd8cc87a4aa815fed553610911be558f027aee54af8b599c78b501"
  revision 2

  bottle do
    cellar :any
    sha256 "26b8710ae06c3026ecd0118e67480bf1bda821a833515c3fb203642a933f955b" => :sierra
    sha256 "42e3a6488ccacbcdcf774c8f46cc6809d3b78d9774f21b5304606cc088205202" => :el_capitan
    sha256 "6aeb9ddcac1d873b51f290efa268c3c1f810778aa77e666796b7c1d08e60e775" => :yosemite
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
    (testpath/"mat.c").write <<-'EOS'.undent
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

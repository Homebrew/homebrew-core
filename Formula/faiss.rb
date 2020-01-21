class Faiss < Formula
  desc "Efficient similarity search and clustering of dense vectors"
  homepage "https://github.com/facebookresearch/faiss"
  url "https://github.com/facebookresearch/faiss/archive/v1.6.1.tar.gz"
  sha256 "827437c9a684fcb88ee21a8fd8f0ecd94f36e2db213f74357d0465c5a7e72ac6"

  depends_on "libomp"

  def install
    system "./configure", "--without-cuda",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <faiss/IndexFlat.h>

      int main()
      {
          faiss::IndexFlatL2 index(64);
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "-L#{lib}", "-lfaiss", "test.cpp", "-o", "test"
    system "./test"
  end
end

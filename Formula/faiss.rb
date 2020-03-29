class Faiss < Formula
  desc "Efficient similarity search and clustering of dense vectors"
  homepage "https://github.com/facebookresearch/faiss"
  url "https://github.com/facebookresearch/faiss/archive/v1.6.2.tar.gz"
  sha256 "8be8fcb943e94a93fb0796cad02a991432c0d912d8ae946f4beb5a8a9c5d4932"

  bottle do
    cellar :any
    sha256 "2ed35e49a096403ccf38e721a9d76aee9690ecf307bf9279fe56e158933d22bc" => :catalina
    sha256 "6e4c9e7c66c700cbce22296fb258ec6e779118acef74741e1bfcadab389634a7" => :mojave
    sha256 "2ca185b2dc508c2d8b7a3f44779a603c199db50000da6aea6ac66c802f3867cc" => :high_sierra
  end

  depends_on "libomp"

  def install
    system "./configure", "--without-cuda",
                          "--prefix=#{prefix}",
                          "ac_cv_prog_cxx_openmp=-Xpreprocessor -fopenmp",
                          "LIBS=-lomp"
    system "make"
    system "make", "install"
    pkgshare.install "demos"
  end

  test do
    cp pkgshare/"demos/demo_imi_flat.cpp", testpath
    system ENV.cxx, "-std=c++11", "-L#{lib}", "-lfaiss", "demo_imi_flat.cpp", "-o", "test"
    assert_match "Query results", shell_output("./test")
  end
end

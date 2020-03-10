class Faiss < Formula
  desc "Efficient similarity search and clustering of dense vectors"
  homepage "https://github.com/facebookresearch/faiss"
  url "https://github.com/facebookresearch/faiss/archive/v1.6.2.tar.gz"
  sha256 "8be8fcb943e94a93fb0796cad02a991432c0d912d8ae946f4beb5a8a9c5d4932"

  bottle do
    cellar :any
    sha256 "fd642e2ffd4b59242131707b9fd83eb0b8cd2299e33e9d6d81e6e8627ff4186c" => :catalina
    sha256 "6520670d92974efc45dad09c56e3348021601154438bed8d40a8b8e86f23493a" => :mojave
    sha256 "e8cb0c3cdc94b90b59b64c918519d3c657e7bae66af63c99a8f6636b20edc578" => :high_sierra
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

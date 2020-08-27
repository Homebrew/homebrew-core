class Brotli < Formula
  desc "Generic-purpose lossless compression algorithm by Google"
  homepage "https://github.com/google/brotli"
  url "https://github.com/google/brotli/archive/v1.0.8.tar.gz"
  sha256 "6dcc73364b1a1ee7e49024d25e00b8ca4968396a81af99c8c6eb8757b52f74ea"
  license "MIT"
  head "https://github.com/google/brotli.git"

  bottle do
    cellar :any
    sha256 "81be7d1d110787a534cd57cc1ec6bb5032d81e3928d9103ce1e654560c6848ca" => :catalina
    sha256 "d2d4f821f8d9c52de15a4d3b5ddeab760ad9ae71105f1c859b7811adff9af9da" => :mojave
    sha256 "700e223c43dff6781343568d3b0838c3ae66381307293c40312c1941b74fb9c6" => :high_sierra
    sha256 "5f38b687e2e1bc18aeecc6598723bcbf0d6c89385e4b227678bc8d97e60890be" => :sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "VERBOSE=1"
    system "ctest", "-V"
    system "make", "install"
  end

  test do
    (testpath/"file.txt").write("Hello, World!")
    system "#{bin}/brotli", "file.txt", "file.txt.br"
    system "#{bin}/brotli", "file.txt.br", "--output=out.txt", "--decompress"
    assert_equal (testpath/"file.txt").read, (testpath/"out.txt").read
  end
end

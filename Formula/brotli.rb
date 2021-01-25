class Brotli < Formula
  desc "Generic-purpose lossless compression algorithm by Google"
  homepage "https://github.com/google/brotli"
  url "https://github.com/google/brotli/archive/v1.0.9.tar.gz"
  sha256 "f9e8d81d0405ba66d181529af42a3354f838c939095ff99930da6aa9cdf6fe46"
  license "MIT"
  head "https://github.com/google/brotli.git"

  bottle do
    cellar :any
    sha256 "9d3009fd246d0f6cf9fd11d0a3bd388f6c043c75fa302decf0dd935163fb0f4b" => :big_sur
    sha256 "bcd00b6f423ec35f98aec55bc2c1cf433b6e70e915cdf04dd2c3a3707f1ce341" => :arm64_big_sur
    sha256 "a382d95787cc2a5742a1d713f939bbc91ca6e097aee7f49f95cc111dca9fa9d7" => :catalina
    sha256 "d121eaa3e670d5ad972514a4cc000326249694c8b9691013e28b8dd52b87410d" => :mojave
    sha256 "126ecc002d37d167252743eb6ff5db19bb6aa4584ab3f731bd7876e438fc6dab" => :high_sierra
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

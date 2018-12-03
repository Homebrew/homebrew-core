class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=arrow/arrow-0.11.1/apache-arrow-0.11.1.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-0.11.1/apache-arrow-0.11.1.tar.gz"
  sha256 "c524f3d47f0cdb7445c0326b20e79f60485e12daeb2adc8ad6a845ad6c19c1ac"
  head "https://github.com/apache/arrow.git"

  bottle do
    cellar :any
    sha256 "702985ab75e66013b03ca0d6b16abbb839bb8ca72a5a11df7ddb630c25eaf544" => :mojave
    sha256 "825cbad795fde15c7f48a22494c3f413a52c6d59048dc0a4570b56308e3447e2" => :high_sierra
    sha256 "04c5ef6542fdfb29eb624d80a465885e8ef946793727fa8e25d6eb067f438139" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "jemalloc"
  depends_on "python"

  needs :cxx11

  def install
    ENV.cxx11

    cd "cpp" do
      system "cmake", ".", *std_cmake_args, "-DARROW_PYTHON=1",
                           "-DPYTHON_EXECUTABLE=#{which "python3"}"
      system "make", "unittest"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "arrow/api.h"
      int main(void)
      {
        arrow::int64();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-larrow", "-o", "test"
    system "./test"
  end
end

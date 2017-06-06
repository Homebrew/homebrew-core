class ApacheArrow < Formula
  desc "Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://github.com/apache/arrow/archive/apache-arrow-0.4.0.tar.gz"
  sha256 "0ce9f47e42735d8d48dd83f9ff6a1612c5f2a8e846f3ae23595697e3519dd9b8"

  head "https://github.com/apache/arrow.git"

  depends_on "boost"
  depends_on "cmake" => :build

  needs :cxx11

  def install
    ENV.prepend_path "PATH", "/usr/local/bin"
    ENV.cxx11

    chdir "cpp"
    system "cmake", ".", *std_cmake_args
    system "make", "unittest"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
    #include "arrow/api.h"
    int main(void)
    {
      arrow::Int64Builder builder(arrow::default_memory_pool(), arrow::int64());
      return 0;
    }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-larrow", "-o", "test"
    system "./test"
  end
end

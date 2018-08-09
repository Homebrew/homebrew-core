class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=arrow/arrow-0.10.0/apache-arrow-0.10.0.tar.gz"
  sha256 "943207a2fcc7ba8de0e50bdb6c6ea4e9ed7f7e7bf55f6b426d7f867f559e842d"
  head "https://github.com/apache/arrow.git"

  bottle do
    cellar :any
    sha256 "ad46f2697053ace2da654ee4752d022f29e1de12d0f4627c12e1c44b9c911334" => :high_sierra
    sha256 "5fb9d7f3e9ba08ec3f39e36f1f264ace354fcc521b1527eddb930102d24a14ca" => :sierra
    sha256 "156b4d5aaa71240da5707376fd4d8f61f9a39f21756dafdadf6180257f9d593f" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "jemalloc"
  depends_on "python" => :optional
  depends_on "python@2" => :optional

  needs :cxx11

  # Fix "Invalid character ('{') in a variable name: 'ENV'"
  # Upstream PR 08 Aug 2018 "[C++] Fix a typo in `FindClangTools.cmake`."
  # See https://github.com/apache/arrow/pull/2404
  patch do
    url "https://github.com/apache/arrow/pull/2404.patch?full_index=1"
    sha256 "77a03e841186e132b44d8a6212c7ca6934b1b9bd77173f91cff53507b0906f3e"
  end

  def install
    ENV.cxx11
    args = []

    if build.with?("python") && build.with?("python@2")
      odie "Cannot provide both --with-python and --with-python@2"
    end
    Language::Python.each_python(build) do |python, _version|
      args << "-DARROW_PYTHON=1" << "-DPYTHON_EXECUTABLE=#{which python}"
    end

    cd "cpp" do
      system "cmake", ".", *std_cmake_args, *args
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

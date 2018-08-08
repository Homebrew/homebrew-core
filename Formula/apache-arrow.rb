class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=arrow/arrow-0.10.0/apache-arrow-0.10.0.tar.gz"
  sha256 "943207a2fcc7ba8de0e50bdb6c6ea4e9ed7f7e7bf55f6b426d7f867f559e842d"
  head "https://github.com/apache/arrow.git"

  bottle do
    cellar :any
    sha256 "01d7964f039c3fb7b7ae0fe1d7fa1250e31fec7c0364f5c23f02b9d08eb29fde" => :high_sierra
    sha256 "b593917a4afed051e2e1b632610a1aeda585db5c932e5b9cb15241dd866114b4" => :sierra
    sha256 "e58c29b2f8eb2b05f44dca174acacf59fbf4cb71fdc099976e353c339d23ff65" => :el_capitan
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

class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=arrow/arrow-0.11.0/apache-arrow-0.11.0.tar.gz"
  sha256 "1838faa3775e082062ad832942ebc03aaf95386c0284288346ddae0632be855d"
  head "https://github.com/apache/arrow.git"

  bottle do
    cellar :any
    sha256 "dbc02ab8107f00866fbb9790766b5a094c6e094067911a009609c353a4fc4235" => :mojave
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

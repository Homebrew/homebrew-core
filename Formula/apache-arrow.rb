class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  head "https://github.com/apache/arrow.git"

  stable do
    url "https://www.apache.org/dyn/closer.cgi?path=arrow/arrow-0.7.0/apache-arrow-0.7.0.tar.gz"
    sha256 "5d8e976e0c8a5f39087e3cd4c39efd45ad8960ffc5207ed02e999d36dc5b0e79"

    # Remove for > 0.7.0
    # Upstream commit from 21 Sep 2017 "ARROW-1591: C++: Xcode 9 is not
    # correctly detected"
    if DevelopmentTools.clang_build_version >= 900
      patch do
        url "https://github.com/apache/arrow/commit/c470c9c2d.patch?full_index=1"
        sha256 "762265b5903fba98ab5b92e7c3d1632bd0ca3f5fdcf395d67047698e9b74bfcc"
      end
    end
  end

  bottle do
    cellar :any
    sha256 "4afb46a3cc65369fc49b7dd57bbfa097b6a8458aad78232b9ed3f242f7f62cf1" => :high_sierra
    sha256 "2759120287b588d05fb10116d6521d632df7ba297e7ef59ea3ad678085d0304b" => :sierra
    sha256 "5a571f534f97b6ddcd3198aee2c1bcd6cc38e6435debc0d0eb3d9f3b03650779" => :el_capitan
  end

  # NOTE: remove ccache with Apache Arrow 0.5 and higher version
  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "jemalloc"
  depends_on "ccache" => :recommended

  needs :cxx11

  def install
    ENV.cxx11

    cd "cpp" do
      system "cmake", ".", *std_cmake_args
      system "make", "unittest"
      system "make", "install"
    end
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

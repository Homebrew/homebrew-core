class ApacheArrow < Formula
  desc "Columnar in-memory analytics layer designed to accelerate big data"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=arrow/arrow-0.6.0/apache-arrow-0.6.0.tar.gz"
  sha256 "ecf8b36514da9eaef5b7cc894e29933646f2bebb913f36c654ae9789138f0c53"

  head "https://github.com/apache/arrow.git"

  bottle do
    cellar :any
    sha256 "5fc8f63806fd7937e6d0e7c0f0a729aeca7670ddb2f575df5acda8892f0bb129" => :sierra
    sha256 "7c50efe964a487acbd95156319f7bca07c5c3dfeb7817526d3943695e680d083" => :el_capitan
    sha256 "5302db745369a3b16d8dfe3661270b1b15d710d13eca5ecffe9b1742b5c01e97" => :yosemite
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

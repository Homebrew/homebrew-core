class Libsbol < Formula
  desc "Read and write files in the Synthetic Biology Open Language (SBOL)"
  homepage "https://synbiodex.github.io/libSBOL"
  url "https://github.com/SynBioDex/libSBOL/archive/v2.3.2.tar.gz"
  sha256 "c85de13b35dec40c920ff8a848a91c86af6f7c7ee77ed3c750f414bbbbb53924"

  bottle do
    cellar :any
    sha256 "146dd770ce84a2313c3cd1ebf3bbbb2c9c7035b90664130a8754cadb64a31ebe" => :mojave
    sha256 "c263df7dc7a32db5341987c3785183ad6fee9a4e2abcce7983ba84bc3ec1ac70" => :high_sierra
    sha256 "9a85aa1c4eb3f1b1913db75940956698d4085724c8838efa7709d46259429e35" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jsoncpp"
  depends_on "raptor"

  def install
    # upstream issue: https://github.com/SynBioDex/libSBOL/issues/215
    inreplace "source/CMakeLists.txt", "measure.h", "measurement.h"

    system "cmake", ".", "-DCMAKE_CXX_FLAGS=-I/System/Library/Frameworks/Python.framework/Headers",
                         "-DSBOL_BUILD_SHARED=TRUE",
                         "-DSBOL_BUILD_STATIC=FALSE",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "sbol/sbol.h"

      using namespace sbol;

      int main() {
        Document& doc = *new Document();
        doc.write("test.xml");
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++11",
                    "-I/System/Library/Frameworks/Python.framework/Headers",
                    "-I#{Formula["raptor"].opt_include}/raptor2",
                    "-I#{include}", "-L#{lib}",
                    "-L#{Formula["jsoncpp"].opt_lib}",
                    "-L#{Formula["raptor"].opt_lib}",
                    "-ljsoncpp", "-lcurl", "-lraptor2", "-lsbol"
    system "./test"
  end
end

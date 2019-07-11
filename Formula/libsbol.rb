class Libsbol < Formula
  desc "Read and write files in the Synthetic Biology Open Language (SBOL)"
  homepage "https://synbiodex.github.io/libSBOL"
  url "https://github.com/SynBioDex/libSBOL/archive/v2.3.0.0.tar.gz"
  sha256 "a8092390b5df1d3dc8df7b403ec4757c55039ccec40ca8088150e27a4a00c41b"
  revision 1

  bottle do
    cellar :any
    sha256 "5682ee6c2d4dc49ea2d0baefadc21d97a747b9a51fbd1487579facf7bd094e94" => :mojave
    sha256 "d1f0a5ba8104d6cd0a9970d61b81b8176fdf8645fa3dae9823ec80a08b34ede9" => :high_sierra
    sha256 "4e129d64504a45e054a2fab16c6398189c091e7bf00432fccf776986d322fd87" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jsoncpp"
  depends_on "raptor"

  def install
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

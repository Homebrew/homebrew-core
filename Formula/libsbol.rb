class Libsbol < Formula
  desc "Read and write files in the Synthetic Biology Open Language (SBOL)"
  homepage "https://synbiodex.github.io/libSBOL"
  url "https://github.com/SynBioDex/libSBOL/archive/v2.3.0.0.tar.gz"
  sha256 "a8092390b5df1d3dc8df7b403ec4757c55039ccec40ca8088150e27a4a00c41b"
  revision 1

  bottle do
    cellar :any
    sha256 "974ce842996ac65fcb31874389e0659451fe6cabc06a1b3c679e6fff9a2a27a0" => :mojave
    sha256 "ee8e8a563435076bdee91fafe19832750ec91f25d0a32d727cdb505d7c437c3a" => :high_sierra
    sha256 "cfe93d1e977048c7502a5aa1b43514deca305dc66451aafb386f68a304c12492" => :sierra
    sha256 "61efb175a5ae38717e9f939c172e9a249e9138bfa3531e71471d6314c7b61b16" => :el_capitan
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
                    "-I#{include}", "-L#{lib}", "-ljsoncpp", "-lcurl",
                    "-lraptor2", "-lsbol"
    system "./test"
  end
end

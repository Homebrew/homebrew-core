class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/c/castxml/castxml_0.1+git20161215.orig.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/c/castxml/castxml_0.1+git20161215.orig.tar.xz"
  version "0.1+git20161215"
  sha256 "6710486f72ea32020d30e04ff9d6e629a94b79d4fb10b834f93d3f87ebd9c091"
  head "https://github.com/CastXML/castxml.git"

  bottle do
    cellar :any
    sha256 "e13a2cd6f5bb23eb1dec5a6452567d08c2ca1a30615bf65d71ea4b7b2293c02a" => :sierra
    sha256 "bfedb038898e36cd58de455a3c9a98995e1250e38343a9c302c4b9ab18675920" => :el_capitan
    sha256 "c7877bb1dfbdc2473c911fbee1bb601acb9e566bc0b2d36039f4a88cf81ff7c3" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      int main() {
        return 0;
      }
    EOS
    system "#{bin}/castxml", "-c", "-x", "c++", "--castxml-cc-gnu", "clang++", "--castxml-gccxml", "-o", "test.xml", "test.cpp"
  end
end

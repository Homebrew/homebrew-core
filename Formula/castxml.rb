class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  revision 1
  head "https://github.com/CastXML/castxml.git"

  stable do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/c/castxml/castxml_0.1+git20160706.orig.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/c/castxml/castxml_0.1+git20160706.orig.tar.xz"
    version "0.1+git20160706"
    sha256 "28e7df5f9cc4de6222339d135a7b1583ae0c20aa0d18e47fa202939b81a7dada"

    # changes from upstream to fix compilation with LLVM 3.9
    patch do
      url "https://github.com/CastXML/CastXML/commit/e1ee6852c79eddafa2ce1f134c097decd27aaa69.patch"
      sha256 "d47f4566bda6f8592c120052aeec404de371dc27b0ef15d5c337c34f87976901"
    end
  end

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

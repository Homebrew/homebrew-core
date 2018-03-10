class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/c/castxml/castxml_0.1+git20170823.orig.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/c/castxml/castxml_0.1+git20170823.orig.tar.xz"
  version "0.1+git20170823"
  sha256 "aa10c17f703ef46a88f9772205d8f51285fd3567aa91931ee1a7a5abfff95b11"
  revision 2
  head "https://github.com/CastXML/castxml.git"

  bottle do
    cellar :any
    sha256 "2631a24141657b845f4c474b0ce1baea3efbf6d56c3e7b8eabe8f4d48dc46102" => :high_sierra
    sha256 "77950bd5fd2d2f482fbe768048b99745fd95fda6ad67e5d2d13b2d8b91fb3b7c" => :sierra
    sha256 "fd750ed01cb0b5e4724d4ba8cd4da776eaab475cb0d2c724a01131659d13f464" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "llvm@5"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      int main() {
        return 0;
      }
    EOS
    system "#{bin}/castxml", "-c", "-x", "c++", "--castxml-cc-gnu", "clang++", "--castxml-gccxml", "-o", "test.xml", "test.cpp"
  end
end

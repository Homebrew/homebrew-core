class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/c/castxml/castxml_0.1+git20180702.orig.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/c/castxml/castxml_0.1+git20180702.orig.tar.xz"
  version "0.1+git20180702"
  sha256 "00c58b28523496fbeda731656bb022ad55e7c390609f189ebe03b4468292da40"
  head "https://github.com/CastXML/castxml.git"

  bottle do
    cellar :any
    sha256 "48412e52013e09c3830b4eb5653bd447c2b5be398db9b05f71ca1065fa582867" => :mojave
    sha256 "094c47bde5f666aad5078e7b8652f71aca7f14cecb233977e7949e6e721ec685" => :high_sierra
    sha256 "0664be25be8a34110f61ff8cfba1b871aa956b9dfa0e8e0b89e3c75a8b2f6b4f" => :sierra
    sha256 "7c6ed31aa80033884da9f2a3265caaf7a5796736ca1d0f1743e1d93aad2cf993" => :el_capitan
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
    (testpath/"test.cpp").write <<~EOS
      int main() {
        return 0;
      }
    EOS
    system "#{bin}/castxml", "-c", "-x", "c++", "--castxml-cc-gnu", "clang++", "--castxml-gccxml", "-o", "test.xml", "test.cpp"
  end
end

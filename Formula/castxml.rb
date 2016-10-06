class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/c/castxml/castxml_0.1+git20160706.orig.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/c/castxml/castxml_0.1+git20160706.orig.tar.xz"
  version "0.1+git20160706"
  sha256 "28e7df5f9cc4de6222339d135a7b1583ae0c20aa0d18e47fa202939b81a7dada"

  head "https://github.com/CastXML/castxml.git"

  bottle do
    sha256 "3ef2c6ffd4953012eb945c3742be3306e4221ad5edc44410b40b47d12a64aec9" => :sierra
    sha256 "5022fdb1cdac50659adb2a2c6438216ecb246f8b6254b672890f005c1bb0a0cb" => :el_capitan
    sha256 "df8baff500313f946a09a64bd1bb4a56d909ad4cce7d1c1eb1dcf637215b5183" => :yosemite
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

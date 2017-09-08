class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/c/castxml/castxml_0.1+git20170823.orig.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/c/castxml/castxml_0.1+git20170823.orig.tar.xz"
  version "0.1+git20170823"
  sha256 "aa10c17f703ef46a88f9772205d8f51285fd3567aa91931ee1a7a5abfff95b11"
  revision 1
  head "https://github.com/CastXML/castxml.git"

  bottle do
    cellar :any
    sha256 "2ed81c48d965c164f090b8867650ad0bb22fdceefac1ffb631cfe71f2a835a6f" => :sierra
    sha256 "8efbc1538492369d8d5d11f4ab66efbc6ab2c2cc405cc3204b684aba5a5ba05e" => :el_capitan
    sha256 "c3a892f7d51146dca4124c62e8b8222b733f5d968348f76f367ae6ba9ffc44c3" => :yosemite
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

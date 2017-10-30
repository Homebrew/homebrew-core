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
    sha256 "2b492ee4cedbc2c225798add5492155b04d7b9d661c265b55bc3f6bdbe8f5efd" => :high_sierra
    sha256 "20ecdeb7cf69686765614ac7a408778866d05f6d53dab99b4dadca833a0a913e" => :sierra
    sha256 "f0cf6a659bf4df48891080168307d82280ae50014af339c643f4ee173e42312d" => :el_capitan
    sha256 "3abae7e083d39e6394f1ffff5fee6e4df9f3b6554ea18e79c711a24b0699fccd" => :yosemite
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

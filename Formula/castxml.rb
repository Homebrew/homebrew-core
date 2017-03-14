class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/c/castxml/castxml_0.1+git20161215.orig.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/c/castxml/castxml_0.1+git20161215.orig.tar.xz"
  version "0.1+git20161215"
  sha256 "6710486f72ea32020d30e04ff9d6e629a94b79d4fb10b834f93d3f87ebd9c091"
  revision 1
  head "https://github.com/CastXML/castxml.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ea5c8e92c0d7c8e6272052483fd7c8855210f38ae2fc25baa72991d5e434c44" => :sierra
    sha256 "90e4164c4edd2d25bed79bfd899eca8e6fa93abf37153e51d98638eb2c877dd3" => :el_capitan
    sha256 "04b33bed48c91f5ecc6f10bde710f6ddffc929bf19560618c505c7f7cfc3d904" => :yosemite
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

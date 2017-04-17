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
    sha256 "f51900fd4d0cdfc42f906bec02d6aa1f0ab1e61534286399cf6a27d3b81859f0" => :sierra
    sha256 "28833ef17f73e31fb027ef03462b3286075debc389804f8c5ab52926be9799f9" => :el_capitan
    sha256 "9854355c02848557c56fcc7cb0bb1e66aa88baff85a5844bc3e11a35b7b93005" => :yosemite
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

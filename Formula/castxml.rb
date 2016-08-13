class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/c/castxml/castxml_0.1+git20160412.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/c/castxml/castxml_0.1+git20160412.orig.tar.gz"
  version "0.1+git20160412"
  sha256 "d65a4e447e1315021c8230f806100c4a812edeff48b8ce564998066315599c86"

  head "https://github.com/CastXML/castxml.git"

  bottle do
    sha256 "bc1065e80602883cb30031cd013cc0236042c91adc256b12dbc9d47bfcc9fa10" => :el_capitan
    sha256 "3f0477a1c2d122dcf7a2dfc5751c8f694fb2f17a5e12a6fc423176c444823de4" => :yosemite
    sha256 "92b2257dcb668e4ea0a1bfaf0720c9b04d79276138397b93424455efca3968cc" => :mavericks
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

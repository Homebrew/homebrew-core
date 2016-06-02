class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/c/castxml/castxml_0.1+git20160412.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/c/castxml/castxml_0.1+git20160412.orig.tar.gz"
  version "0.1+git20160412"
  sha256 "d65a4e447e1315021c8230f806100c4a812edeff48b8ce564998066315599c86"

  head "https://github.com/CastXML/castxml.git"

  bottle do
    sha256 "c132699f62f6ba49ee0c71a75701a024bacf941ff0d9b48600a2964fb0f522f4" => :el_capitan
    sha256 "bf45ee81179a7c03503be7ad1e35b44fe9399fcf928ab694eaa69bc058862345" => :yosemite
    sha256 "2a083561ee404e8548eb4fe75a8b0c496493de3ed2a65c7e0b06264bf07cdc12" => :mavericks
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

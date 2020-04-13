class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://github.com/CastXML/CastXML/archive/v0.3.3.tar.gz"
  sha256 "9b8b9d6dd16dfa79c2291c025551b71654856cf525447e3616cae8f1c0a30e0f"
  head "https://github.com/CastXML/castxml.git"

  bottle do
    cellar :any
    sha256 "5ec79b331bd18ac2d619c2acb01c42ccfabac62898f5e83971d9594fea1e91ed" => :catalina
    sha256 "3a87a080247a21ab0f05db2dafb826664bb88426563507bb6a00d9c465d41e62" => :mojave
    sha256 "295056ef0feae25c6f00c1e7e669f7f017bc3242c4cbdb0d6c95b34568b31655" => :high_sierra
    sha256 "aaf5927a5f3dfcdc3c88a936a2aa6964ff8f304c48a0690087e6350ef75b0206" => :sierra
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
    system "#{bin}/castxml", "-c", "-x", "c++", "--castxml-cc-gnu", "clang++",
                             "--castxml-gccxml", "-o", "test.xml", "test.cpp"
  end
end

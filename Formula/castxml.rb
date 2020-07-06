class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://github.com/CastXML/CastXML/archive/v0.3.4.tar.gz"
  sha256 "a597ef37fe2b43fe3cf2c0c4e2ed0069d5aba2714016c319ac47787760859df4"
  license "Apache-2.0"
  head "https://github.com/CastXML/castxml.git"

  bottle do
    cellar :any
    sha256 "2cca1b4b5c7298f2e385a5d24f0c507fde75691d70bb45fdc4e52092c02356da" => :catalina
    sha256 "5eab772fc46e134783b1339b365c894bae9d2a15d714579206fb9a92a6c63964" => :mojave
    sha256 "65232354608516831cd91b5e705e12551b09a6df773fbce9475fa609d3cefc32" => :high_sierra
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

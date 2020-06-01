class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://github.com/CastXML/CastXML/archive/v0.3.4.tar.gz"
  sha256 "a597ef37fe2b43fe3cf2c0c4e2ed0069d5aba2714016c319ac47787760859df4"
  head "https://github.com/CastXML/castxml.git"

  bottle do
    cellar :any
    sha256 "28c61550d6b765a9863362591763f66a1fc1037badba2ee546feb1472b70a35e" => :catalina
    sha256 "b07287af4db5039c8672fe8c403f3de524b0b40eda3f530846870acdcaf0501a" => :mojave
    sha256 "5e69cca3d29aba3ff0f2ad85db57253db89d14c003503387d69e58d4a0ad595d" => :high_sierra
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

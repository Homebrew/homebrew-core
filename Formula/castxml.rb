class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://github.com/CastXML/CastXML/archive/v0.4.1.tar.gz"
  sha256 "265c84237b728b6cd9fe6106f51873d3c547cde98023259e511c807aef1e39f7"
  license "Apache-2.0"
  head "https://github.com/CastXML/castxml.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "9e74e042eac6e8b850794aa3da582fe576e40113c50efccfe8341f0b23f9e6f0" => :big_sur
    sha256 "e8c8f490a7f119aca640d6479cf6277e9fcfd0b0900ba99f7a5da7f6ae1598b9" => :arm64_big_sur
    sha256 "40ba6dbece97b3ced1ab3e911d325233c8ad1f1f08d683dd19c9b9eb84f00b42" => :catalina
    sha256 "61c4ebf7c46c1a56aada4eb6e4dcf8fe6a609d67515ed3e47ad1e567cea449f6" => :mojave
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

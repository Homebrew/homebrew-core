class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://github.com/CastXML/CastXML/archive/v0.3.6.tar.gz"
  sha256 "e51a26704864c89036a0a69d9f29c2a522a9fa09c1009e8b8169a26480bb2993"
  license "Apache-2.0"
  revision 1
  head "https://github.com/CastXML/castxml.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "4a537198ce8aee0845b9484d68d20d4289e42e2da48d6a4bbdbd94055a94a707" => :catalina
    sha256 "1146417a17592ed5cfffaacd1c854cec76096aafd06371ef4531927dcb891400" => :mojave
    sha256 "5eed2dad7a6c3ae7aa4aebfa0dec57f6624f842480deb8ec69a4f9c6afd7bade" => :high_sierra
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

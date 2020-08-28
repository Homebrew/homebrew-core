class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://github.com/CastXML/CastXML/archive/v0.3.6.tar.gz"
  sha256 "e51a26704864c89036a0a69d9f29c2a522a9fa09c1009e8b8169a26480bb2993"
  license "Apache-2.0"
  head "https://github.com/CastXML/castxml.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "94306cb188a0ddd74b5bdae5f7b573f5f89223b564f82baf35399028316addda" => :catalina
    sha256 "a46d5dfe088b523f7000c436381223712ee806ec0bfbf3365f20dc4b3ac1d1ae" => :mojave
    sha256 "0d468f10b51a618c41e7aa6a637c574b28682108eb7ed87dfb3abd7e80430c70" => :high_sierra
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

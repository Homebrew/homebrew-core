class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://github.com/CastXML/CastXML/archive/v0.4.3.tar.gz"
  sha256 "3dd94096e07ffe103b2a951e4ff0f9486cc615b3ef08e95e5778eaaec667fb65"
  license "Apache-2.0"
  revision 1
  head "https://github.com/CastXML/castxml.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "a621a2f54f8b157f47251f7d92032e4ecf9e4611995979533b5a9176f3849057"
    sha256 cellar: :any, big_sur:       "baef1dc2e08d7d0a0f276c54a3f180d662abc1cd660a875aec2c6db8ddace248"
    sha256 cellar: :any, catalina:      "7e97d6cb586ba2ffbcc00bcfaf146c5cf6838aaa01f6ef83a2c8033ab34f6acd"
    sha256 cellar: :any, mojave:        "5a24c3bad04790815e3af774e12ad5f9d800318dfaf9bc6b8b3bef7b32db61ea"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

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

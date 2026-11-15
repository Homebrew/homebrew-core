class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://github.com/CastXML/CastXML/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "68e91af54851ef341fae72299f7576892c3317f7b40d00590ed79d00dc30a16c"
  license "Apache-2.0"
  head "https://github.com/CastXML/castxml.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "039a14ae39047740a8b6850f53d88148b722bc071cd37395bb8a44c71cfae1f9"
    sha256 cellar: :any, arm64_tahoe:       "66736a050176a0b00c1e9e4ce673d27d54bf71de45418a1fdf4237f9802febaa"
    sha256 cellar: :any, arm64_sequoia:     "c9731c93b32a473bd9068438e8d5d883a20b26c2c5320779af2ada2d291aede8"
    sha256 cellar: :any, arm64_linux:       "d95073b63b918f63e3539542ddb83ceb1f695df7f2460e1ab2264564e8295ffe"
    sha256 cellar: :any, x86_64_linux:      "55dd10254d28551c47b417bd90e058dc37ee7389442816de913f4a1a9fa88cb4"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      int main() {
        return 0;
      }
    CPP
    system bin/"castxml", "-c", "-x", "c++", "--castxml-cc-gnu", ENV.cxx,
                          "--castxml-gccxml", "-o", "test.xml", "test.cpp"
  end
end

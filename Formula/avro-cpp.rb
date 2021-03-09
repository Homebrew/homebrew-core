class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.10.1/cpp/avro-cpp-1.10.1.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.10.1/cpp/avro-cpp-1.10.1.tar.gz"
  sha256 "6e9e8820325cdaffcc1981958ed86b484c33dcf0277a164b2a58357fdd046cc8"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_big_sur: "a0483d513cf45e07a900217f40380f2877f24d76bed80eca97c3a1847d319f00"
    sha256 cellar: :any, big_sur:       "ca9e68702c6db225ae771e492cf3ad1ea810ab325fbb9909b4c4dd6db7134076"
    sha256 cellar: :any, catalina:      "26406c1a5d27a8f5d73a444ff79ed97f975764e178074c8093edcb0322292e43"
    sha256 cellar: :any, mojave:        "46756dffcea14bc4cc3f264f8a33e99eb553470423ca53f58c0499b80a16f1f4"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"cpx.json").write <<~EOS
      {
          "type": "record",
          "name": "cpx",
          "fields" : [
              {"name": "re", "type": "double"},
              {"name": "im", "type" : "double"}
          ]
      }
    EOS
    (testpath/"test.cpp").write <<~EOS
      #include "cpx.hh"

      int main() {
        cpx::cpx number;
        return 0;
      }
    EOS
    system "#{bin}/avrogencpp", "-i", "cpx.json", "-o", "cpx.hh", "-n", "cpx"
    system ENV.cxx, "test.cpp", "-o", "test"
    system "./test"
  end
end

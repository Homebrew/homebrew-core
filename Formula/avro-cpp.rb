class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.11.0/cpp/avro-cpp-1.11.0.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.11.0/cpp/avro-cpp-1.11.0.tar.gz"
  sha256 "ef70ca8a1cfeed7017dcb2c0ed591374deab161b86be6ca4b312bc24cada9c56"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "afc1ca56809de324699a3591a9cfc69b64910abd765ed5ed23fc147ed3f3e981"
    sha256 cellar: :any,                 arm64_big_sur:  "a1dc26c7cc77ab1336819aa3b9cfa89d92829a58b1379fa7fc272e292dc3a7ca"
    sha256 cellar: :any,                 monterey:       "62f6406c61b7ee09446b866e30b2718ff17323ae7341d9c30cba748cf1ef0e93"
    sha256 cellar: :any,                 big_sur:        "c6d71d0ccb148b12c2d3418a9b9a39c224e3166e5f375f9833b5c11d070c48a0"
    sha256 cellar: :any,                 catalina:       "4d94de0a0aaf77588d3c0f0b3255861ec89c24d5235dedd4a190f3ba4256b94b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f29988613e601a8240626aac694acebd0410c9777521ce30b30a550a9c84035"
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
    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test"
    system "./test"
  end
end

class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.11.0/cpp/avro-cpp-1.11.0.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.11.0/cpp/avro-cpp-1.11.0.tar.gz"
  sha256 "ef70ca8a1cfeed7017dcb2c0ed591374deab161b86be6ca4b312bc24cada9c56"
  license "Apache-2.0"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d28e6e8ad94ce88d639e2bf47c8380ca870bafb12765c8c8864574ad7327f3f6"
    sha256 cellar: :any,                 arm64_monterey: "ddaa7f7c209a439f8f7b62d8abcbd16b90f11d31f3e61e63804665b405efd4fb"
    sha256 cellar: :any,                 arm64_big_sur:  "4976ca9f300014464f37566598860ec3e045422102d7bd25d572cfcc366b3ce0"
    sha256 cellar: :any,                 ventura:        "0b5163bb5e6084a52a5d904c8ec73273cae339257cb708f01ce172a18e21769f"
    sha256 cellar: :any,                 monterey:       "cb85f45a2e61112b1e8402c1729b0d394367f419ca0b7c54ab7716a7e83ea3a6"
    sha256 cellar: :any,                 big_sur:        "ff16bcf7ee8aee89bf6112f37a8dc46b6c3290618471a0c3cc6c8f285ab20250"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a19f4faf655588028005cc3fe90b56e92505a2d170e2c1d4029d44a623adc1a"
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

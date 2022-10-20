class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.11.0/cpp/avro-cpp-1.11.0.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.11.0/cpp/avro-cpp-1.11.0.tar.gz"
  sha256 "ef70ca8a1cfeed7017dcb2c0ed591374deab161b86be6ca4b312bc24cada9c56"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "77718ea59837565dd4e1c18261dce764f0289e77037b3f9a98cf25f86177ddb7"
    sha256 cellar: :any,                 arm64_big_sur:  "00aefc17916fcf9db163d87277e8cc6a39de888808fe632b65c85502e9b8ad6e"
    sha256 cellar: :any,                 monterey:       "f2c81739502b2119c1193b6a085c7c8dbd50af8b844ff38834f2a5b6413e0298"
    sha256 cellar: :any,                 big_sur:        "a5201a6b40e7be69951a963b87f68e1eeb27a1beaa3b3a2234bb4422bd728b0c"
    sha256 cellar: :any,                 catalina:       "9826694c526d5e952bafa2b547d5a85b877210c5f04955f0ec9e2dcc3e67c732"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b85f66f032be7576b415536acf99121444cf81b7ee257422fc516f4a6f27c041"
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

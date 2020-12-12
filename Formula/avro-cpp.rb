class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.10.1/cpp/avro-cpp-1.10.1.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.10.1/cpp/avro-cpp-1.10.1.tar.gz"
  sha256 "6e9e8820325cdaffcc1981958ed86b484c33dcf0277a164b2a58357fdd046cc8"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "2e55bbf452cda387741680072bc687f0581eb6c03512aa2a8caed4aa1f8f75e2" => :big_sur
    sha256 "6a5ce5f43fca2b3ccef25b61c7604fb82a750a1e21c23c0978c3db7e5b3c3db7" => :catalina
    sha256 "32eaf017aa3a648ef5cf556b529e80a1853d94b0114089ffa56a7f7bb6b16948" => :mojave
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

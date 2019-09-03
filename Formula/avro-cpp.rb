class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=avro/avro-1.9.1/cpp/avro-cpp-1.9.1.tar.gz"
  sha256 "ff0c98f6f81294167677b221edcdd56b350fac523d857a5f53cf7fcd2187c683"

  bottle do
    cellar :any
    sha256 "c1a6da3aea6266e910ffefb7a533f87fbfcca1d60e332a912fe5fc5e9d2cbaff" => :mojave
    sha256 "c448552e93e0de5f880ac1894b1deaa33596b33c63f554fbb17fca78f87d47b2" => :high_sierra
    sha256 "3219656e529aea6eb7b8c8f66c1e6bbcec3a6be82c54c0da008dd0cf8c0e5094" => :sierra
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

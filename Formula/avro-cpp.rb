class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=avro/avro-1.9.1/cpp/avro-cpp-1.9.1.tar.gz"
  sha256 "ff0c98f6f81294167677b221edcdd56b350fac523d857a5f53cf7fcd2187c683"
  revision 1

  bottle do
    cellar :any
    sha256 "999bed28804705dacec3f43a036c7702a2fb25e8dd4df0d3f728da90b8491d74" => :catalina
    sha256 "c8914248f52cfdb0b14bdc2a35265b57e63188d90734697f54cbf190838da70f" => :mojave
    sha256 "5b663117e9a813100c712de902a12499e56a0f242425e79e50e964e2239d8b96" => :high_sierra
    sha256 "75e045cca21a51f2ea403edca2dc5f17f1a164969f02b605bdc3e7f733abe64d" => :sierra
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

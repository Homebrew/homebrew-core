class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.10.2/cpp/avro-cpp-1.10.2.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.10.2/cpp/avro-cpp-1.10.2.tar.gz"
  sha256 "41ff2ddb9dab64af195c248cb10165dffe026e8aac8f572a22380a5c60e762e3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d9fdbe9ff1518660f724042a38482903b76d0846ccc9da1c6604a02f3dccfa8f"
    sha256 cellar: :any, big_sur:       "4d6f750dfc9eef39e2162dfcbe2b58d1e6eeb5dfc009b8588670ce507055e0e0"
    sha256 cellar: :any, catalina:      "fbb5bc2cd39d90593999508803ab578b99816d013d7a1893dfb6451d1ce8d150"
    sha256 cellar: :any, mojave:        "c78681f2af65e8f8468de1a8397b3d9bbd6a95285357eec25fc34e9b853b53a0"
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

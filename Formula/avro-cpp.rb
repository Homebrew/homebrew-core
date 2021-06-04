class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.10.2/cpp/avro-cpp-1.10.2.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.10.2/cpp/avro-cpp-1.10.2.tar.gz"
  sha256 "41ff2ddb9dab64af195c248cb10165dffe026e8aac8f572a22380a5c60e762e3"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_big_sur: "4e3f32810c14784dd0ca987c17a9b856b185dbc6afc35182db163c84e3a65d17"
    sha256 cellar: :any, big_sur:       "ffc4344248885e70654865d0af257e35636457fa72156c47426fe35faef0a774"
    sha256 cellar: :any, catalina:      "6c43dff6c00e50eff20e9ce2748d72803b4f231c247393dc72c7d3153f296e9e"
    sha256 cellar: :any, mojave:        "4ce55a01bd22f9e7f02af016bc3477e70c641ccca081de4cfd5c54fbfda4f3fc"
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

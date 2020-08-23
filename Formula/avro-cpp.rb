class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.10.0/cpp/avro-cpp-1.10.0.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.10.0/cpp/avro-cpp-1.10.0.tar.gz"
  sha256 "ab016fa07c5759dc5ab8464214fc942833537f3419659a5df53ab7e3f1e809ec"
  license "Apache-2.0"
  revision 1

  bottle do
    cellar :any
    sha256 "618662a57f5f58951082971df4fdd63331bf5fe932aea2533012968d98d32ed0" => :catalina
    sha256 "0ec4b472c30ee648bf368b93fb74c1842ae5d29860ce8d01ef1c4e291f52114d" => :mojave
    sha256 "8695f1ff16d26c3dfbfd0ee0bd8b17a9fb3dfe9f6da71e0802b49825691cdcaf" => :high_sierra
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

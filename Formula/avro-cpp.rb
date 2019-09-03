class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=avro/avro-1.9.1/cpp/avro-cpp-1.9.1.tar.gz"
  sha256 "ff0c98f6f81294167677b221edcdd56b350fac523d857a5f53cf7fcd2187c683"

  bottle do
    cellar :any
    sha256 "8fcc26c4a11b256e76b7a9db4115bb5e00fffe8d0b44d07d5e52caf8812317a9" => :mojave
    sha256 "702007c9685e8c9c09ecb3a3b24f4a234e8c152de713a01b54f8c7357f57c754" => :high_sierra
    sha256 "61f017da24e1b5da7a67d57f24ce5be6fe6c7c7336b32a181c3eaf359724bd93" => :sierra
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

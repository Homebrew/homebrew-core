class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=avro/avro-1.9.0/cpp/avro-cpp-1.9.0.tar.gz"
  sha256 "3a66aa600dbb171cda4664fce1c5a73a9720c8b0f55b13f76650453be6d6ab97"

  bottle do
    cellar :any
    sha256 "8a05fbeddd6c8ed0c942eb18bce185d8bdf6cbd0cfadf13c5a0916164ead4964" => :mojave
    sha256 "38e7dd9b74cbc673a2564898075d75b38c17fa9690b014bb5955b511c6ee6bb1" => :high_sierra
    sha256 "59510bd149f8600f5dcff4915a67bd4600ff3c150ed20cfe30e3d58a8073eaae" => :sierra
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

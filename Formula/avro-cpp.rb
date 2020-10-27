class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.10.0/cpp/avro-cpp-1.10.0.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.10.0/cpp/avro-cpp-1.10.0.tar.gz"
  sha256 "ab016fa07c5759dc5ab8464214fc942833537f3419659a5df53ab7e3f1e809ec"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "daf0cbf609b4fa29127875b3235e1c6e6f4da0b0eef0719b13efe5654421d7d7" => :catalina
    sha256 "42131dfe9b4c80ddd3687be2f0b2210cb45ebeb3f1189acad8af4f402b892e2c" => :mojave
    sha256 "c0b0f79d21e69a75ab3ffaf86344838082fcd6dd3927230e655ae881cd86076c" => :high_sierra
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

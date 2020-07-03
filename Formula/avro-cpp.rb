class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.10.0/cpp/avro-cpp-1.10.0.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.10.0/cpp/avro-cpp-1.10.0.tar.gz"
  sha256 "ab016fa07c5759dc5ab8464214fc942833537f3419659a5df53ab7e3f1e809ec"

  bottle do
    cellar :any
    sha256 "901250460aa31156d6ce19869652e02f0e50611d140a5e27481a46fd960b263d" => :catalina
    sha256 "a19b21f30750357841d9878346de2ea08a423e095e018c5db3df30109973d230" => :mojave
    sha256 "15922816ec925ce88947d027d6abb1a5b250ece5d66ef6696fe0bafc33240fb7" => :high_sierra
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

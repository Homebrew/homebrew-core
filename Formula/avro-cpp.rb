class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.10.1/cpp/avro-cpp-1.10.1.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.10.1/cpp/avro-cpp-1.10.1.tar.gz"
  sha256 "6e9e8820325cdaffcc1981958ed86b484c33dcf0277a164b2a58357fdd046cc8"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "6f51a239801589187903594eae05312d66b0e75c9aa1ff2eb35676656c8a5e71" => :big_sur
    sha256 "ea71e8ee1e1274fed73fc1c748a2952104ddd2bcc9b06ae01bc7ca21caa7a637" => :arm64_big_sur
    sha256 "1c1ae120fb6ed8cb52d4ed74bc7ec80fb75c91f8963c4f6a71963d2bbd32c8e6" => :catalina
    sha256 "a64e584250028e59dc419d9a65a0f34b0bf74f24077b469531320bc3d95fa039" => :mojave
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

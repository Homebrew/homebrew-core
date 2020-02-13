class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=avro/avro-1.9.2/cpp/avro-cpp-1.9.2.tar.gz"
  sha256 "bd50f380ed4f77231721ee2347dd0ca3991f6fec5254acdf7e5f105253deba6b"

  bottle do
    cellar :any
    sha256 "fcc7ee8e6e475ce422cff0c4c1739d36eca60e7a2a17608ba909255f8b569970" => :catalina
    sha256 "191067383e33e1a8673557756ff036a8353e31ae9a35811d5da33bbed2ecc6f7" => :mojave
    sha256 "df2f4402f575b414744db02178ac81ae7f90f404f57aa95eb9cbf66c5bfc833d" => :high_sierra
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

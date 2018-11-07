class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=avro/avro-1.8.2/cpp/avro-cpp-1.8.2.tar.gz"
  sha256 "5328b913882ee5339112fa0178756789f164c9c5162e1c83437a20ee162a3aab"

  bottle do
    cellar :any
    sha256 "0a45a73085609cd13b6f4b65194f60caf507c3f624a458c09d4409dd7ae6eee4" => :mojave
    sha256 "92474608c57be07c5453914f40ac5579affe1c2852776c99784559028ae61808" => :high_sierra
    sha256 "319664d5b1f6dcfca5485ca7e30c10b316a6b865658bb4d86e94036312400792" => :sierra
    sha256 "608da3caf3b22380430f27975bd00c240f9b852fb7b2bfa1a06c91ff25bf6245" => :el_capitan
    sha256 "30de5dd8b0328916218197bf57e6d74695c770a9c53194a0ec4d2676934dc27b" => :yosemite
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

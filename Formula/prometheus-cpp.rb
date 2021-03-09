class PrometheusCpp < Formula
  desc "Prometheus Client Library for Modern C++"
  homepage "https://github.com/jupp0r/prometheus-cpp"
  url "https://github.com/jupp0r/prometheus-cpp.git",
      tag:      "v0.12.1",
      revision: "38130aee330377d6289a076628dbe450d59ef3e9",
      shallow:  false
  license "MIT"
  head "https://github.com/jupp0r/prometheus-cpp.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "512cde8acc7dd926f3262100de76d8e5ef18a668699bcd88c4e666955ba62296"
    sha256 cellar: :any_skip_relocation, big_sur:       "736af213f2ba5a31cae9ed98e240b3af852cf055852d861d15bb15f5402d2b87"
    sha256 cellar: :any_skip_relocation, catalina:      "23b409e2a0f5f8be64f0388b99a4acb16a226d3324d81694c9adff105bd8630d"
    sha256 cellar: :any_skip_relocation, mojave:        "4c5f320dce92274cf8985ea805f9ce1048daa2a0464f4f25a618010d3554b400"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <prometheus/Registry.h>
      int main() {
        prometheus::Registry reg;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{lib}", "-lprometheus-cpp-core", "-o", "test"
    system "./test"
  end
end

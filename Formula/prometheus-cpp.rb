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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "70a31e89a4af6f09ef7cb066ab77af273a7f3cbb48aca8ef7eaa6f745115faab"
    sha256 cellar: :any_skip_relocation, big_sur:       "0300ab178d6db69859e839f636d01d21382728c82e000109e57f6514337ad966"
    sha256 cellar: :any_skip_relocation, catalina:      "b32c20bd785eb14081f392ee9228365a7d73982b757c501951258f6547fb6a73"
    sha256 cellar: :any_skip_relocation, mojave:        "145d8f33887aafd06efbcaf6cd23931c728ce9de4fff31fe67bc0ecf32f65e44"
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

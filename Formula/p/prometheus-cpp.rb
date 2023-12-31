class PrometheusCpp < Formula
  desc "Prometheus Client Library for Modern C++"
  homepage "https://github.com/jupp0r/prometheus-cpp"
  url "https://github.com/jupp0r/prometheus-cpp.git",
      tag:      "v1.2.0",
      revision: "23162a6b77fbe9cf01214e06ec20dacb3a8f09f0"
  license "MIT"
  head "https://github.com/jupp0r/prometheus-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97dfe69cc35fb508987a6dc8588db5b102e5611b173b1c9f8f49872eb6462147"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4762b857239f535eda6ed90ef7e2285dc47034220b20b65b5fa37b7071d13f88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "938ee640303fe3b9e26222c8ab4492a8bcb9ae9adc5facb30d638a797666bcb9"
    sha256 cellar: :any_skip_relocation, sonoma:         "97c2237eacf50f24269e3b8741599bfaf5362267384e9f13b024a51c465b56e9"
    sha256 cellar: :any_skip_relocation, ventura:        "a9c2f983b44079d6eb805a1487d14399786968dfa8b67259e28010c28d5cad0d"
    sha256 cellar: :any_skip_relocation, monterey:       "285f475e55819f74e8b44bc698013ddaa53a77ceda80074cd29fd6c331e96bb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db0374241e4c838f23a783c442e51cd7f943283da812d662833e21bf8d7ff566"
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
      #include <prometheus/registry.h>
      int main() {
        prometheus::Registry reg;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cpp", "-I#{include}", "-L#{lib}", "-lprometheus-cpp-core", "-o", "test"
    system "./test"
  end
end

class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/v2.4.2.tar.gz"
  sha256 "e829d822a6d65cbf89fd3398982b52dac8a6e24834081e605ec30d15cdc42873"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "1ab17cda20f0f054e9044b38640cc36e21e5a5f0cbc561c3c453c6a426cd0690"
    sha256 cellar: :any,                 big_sur:       "87190071798f200822a37d47ce82747b47b512c41858a36058c7430be5937ad0"
    sha256 cellar: :any,                 catalina:      "279d477fea9a61fcc5d61a1d35c6c3b541ceb9f78bafe4306ad36a4bb41e26f4"
    sha256 cellar: :any,                 mojave:        "2e0856dd5923603cecd829b4a9f02a02b15a48f186873b09ae03b0272a4a8413"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8417c81363d502e2de1655e67ca6239977d0d47405b5987817728a9b55e6b70"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "doc"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mkldnn.h>
      int main() {
        mkldnn_engine_t engine;
        mkldnn_status_t status = mkldnn_engine_create(&engine, mkldnn_cpu, 0);
        return !(status == mkldnn_success);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lmkldnn", "-o", "test"
    system "./test"
  end
end

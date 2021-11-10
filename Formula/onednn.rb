class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/oneDNN/archive/v2.4.3.tar.gz"
  sha256 "153bc08827c3007276400262ebdf4234ea7b4cfd2844440dd4641b7b0cc4f88e"
  license "Apache-2.0"
  head "https://github.com/oneapi-src/onednn.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "41411321102b74f8f3d4dd43691ff733338d3db938aab2594ab9aca2b2a2f366"
    sha256 cellar: :any,                 arm64_big_sur:  "deb03168d1e819f7dbb82be005eb69796bf53f0b3e7d7cb922b95213c38aa846"
    sha256 cellar: :any,                 monterey:       "7467355ef6c8d04bd5aea8f9e8123fdb0b5cb356cd8800fadd2477364db6b204"
    sha256 cellar: :any,                 big_sur:        "33464d91f33d0ad7f633eb5395016b5262c24e4f332399fc7a974986ebe9f255"
    sha256 cellar: :any,                 catalina:       "9fbf5bfa7ab278ea9212be24de59229df235eaa11acff3cdd89f970c6038d0bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f408eddcd2d12107b343f933d767c59403643198275d6ea01b1a77c068424c34"
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

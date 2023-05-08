class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "93943cff5f6dad0d603954a718fca99df0284a33b584b5fb6b6c5e13413e6bee"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cb77b01d6db7b63fd985d69cc4f11e33717bfd3e45e18f7aa17f82c01f9d0742"
    sha256 cellar: :any,                 arm64_monterey: "93e8d088866cd08c0d58efc574697f6f747b3d72de0ca62739b2332330cb8411"
    sha256 cellar: :any,                 arm64_big_sur:  "9ba59ffbff689988bfc2d2caa4e936d6e66c9f160417e7e531eaf3fab2dfdc7d"
    sha256 cellar: :any,                 ventura:        "69a2a32a139133a239e45495b2e5026d75a9fed9397a7837590cd0f98346ec1c"
    sha256 cellar: :any,                 monterey:       "0c17e478a94022d34ac9247c34d999cf717fbc8fd7323eff889c371f37b8d5df"
    sha256 cellar: :any,                 big_sur:        "8bbd7c071a9245b1558cab27b281945c80ac7cc0ce712eb74d0a037fa249f06e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0543a623baabfdfa41a2763e61e2b39bb8d0f7c21e6029ca450ebddb139a5e77"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cmake", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdint.h>
      #include <re/re.h>
      int main() {
        return libre_init();
      }
    EOS
    system ENV.cc, "-I#{include}", "-I#{include}/re", "test.c", "-L#{lib}", "-lre"
  end
end

class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "a575adfe8079b3f221176b139b08719efc0260c66c41c3a93424f61dff57e8f8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9a4da52a62a88fb485fb17c7833c64becf7a6b06700e5a1f2bc2fba95ceb2712"
    sha256 cellar: :any,                 arm64_monterey: "a419f1dcee9d25d6fee1a456a6a9f14a380a1750204fd810710eda9479465cb8"
    sha256 cellar: :any,                 arm64_big_sur:  "d5622e30523d8189b2f73c9ba4b51207c2ce689119ca5b507b9a64c5c1dcd409"
    sha256 cellar: :any,                 ventura:        "4e3e663815b96b920e58ee5a21a40603d55e6501e2f7fa715a1adcd0417d37ac"
    sha256 cellar: :any,                 monterey:       "dfb1e6083d667149a739728f38e0e9393364805fa33390cc744497c26f6b5978"
    sha256 cellar: :any,                 big_sur:        "79f3eba2d9611a83da41d1cd4933d4e1638c4f8a48b4c6a23cb1360c5fc9c030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44c833ef100a0ca56d9e9dc613bc9d5e42fc514f2fc909bc94649517442d0b92"
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

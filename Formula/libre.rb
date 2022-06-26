class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "f2b807f6d4cd0ff73e8233d44f81727c013160c0b39b528b056c2d2f93a8fa27"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "cec4a0c328582b03b7b386e11d99ef2d70e3b7506071d88c60ddb6498e4aa69d"
    sha256 cellar: :any,                 arm64_big_sur:  "bb013249efb0bad8fe1ec42eb0b2f9694ad1ccf5ebe5f167e16006d3d07170f4"
    sha256 cellar: :any,                 monterey:       "83fec7ba79ae65020328ea93eae1a2b58250e6cdaa3d4d3b630f8ff38774170b"
    sha256 cellar: :any,                 big_sur:        "0d17e28d0ce1946cb9a5b723b73b9c2ca3b1a4990297e732fe4689eb2a595dac"
    sha256 cellar: :any,                 catalina:       "714908f0cec04646844815add153e9a7b42028981cc03b4d60e40ce0d92bfa69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd7b38953d5d92d54e8c58d07883cbc451275e536b5cebf2ec1f998fa8daad22"
  end

  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    sysroot = "SYSROOT=#{MacOS.sdk_path}/usr" if OS.mac?
    system "make", *sysroot, "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdint.h>
      #include <re/re.h>
      int main() {
        return libre_init();
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lre"
  end
end

class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "5ffcb354d09e416fe6ce12d7245d567c21b396894240c2e137a2a009a6472f83"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5bc9f336f22aa81d3b732f0dc8dead3651d3dfae40480d551464f8ab6f19f120"
    sha256 cellar: :any,                 arm64_big_sur:  "1a497b9c1d3f9308e4acfd44ea5c291178c9d8c2d3bf13d42f863645668aa788"
    sha256 cellar: :any,                 monterey:       "8150099d5b7e255dbc738d52a0b208620b62564e5a99d8050c679ca1bad7623b"
    sha256 cellar: :any,                 big_sur:        "3e9a01c65d13fc15caba8b35079f3be40db5393a5d38b1669d3dbc112a40d499"
    sha256 cellar: :any,                 catalina:       "c96000ce4b17ed1a443ba5b65377fdadc74c5f62c7689c475f5eb397cae49929"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69c917be149cf9df20db90b01b4d08a9fdb029829224421c20163b44e15a7f98"
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

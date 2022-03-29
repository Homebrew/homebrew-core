class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "ecd8c84371ff4fd16dcc9c98c94227e3964da9031908067c0564d6354125c814"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5c8f8e75000fec0d58233ba1d9bc087402b188f8fdd4ba2afb1ae4efee4f2261"
    sha256 cellar: :any,                 arm64_big_sur:  "c845144b9e4dd8d6fb4684b8cd17541d78c6f0c5ae3638b3199c6a464bc44072"
    sha256 cellar: :any,                 monterey:       "f80484fcce155903f92e880b3545811afcc289e5e623985086969786bea4a124"
    sha256 cellar: :any,                 big_sur:        "dda08049001eca8219271309f25f7f04603381e77d9bd72554e5b65f42b1cca9"
    sha256 cellar: :any,                 catalina:       "c4f9d66eed7c6ccf88d4a6e92131996ba5204c0458af2745f967d2d65963c8c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "095bd2f7a18a7c75cc321aaac90ef2a2ecac46fc066d7b092fdc76e91c7d978b"
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

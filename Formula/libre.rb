class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "d820e1bf595b35e5e71f33d131d105aca2c53b05876abfe5e80303aa502583f0"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "68185c640b0b3e7a2fece5b0dbd5324ccc199b46bf06bb0533a2f87b78ee069c"
    sha256 cellar: :any,                 arm64_monterey: "6c1106c9c13760418b17c4ada4384bc04226c51ade387262809760d68da80829"
    sha256 cellar: :any,                 arm64_big_sur:  "ab6d1f01cfbc37a019593fad04e93206eeec47947a8f4f516a99863fc9cef880"
    sha256 cellar: :any,                 ventura:        "6a4cc34c80dc2ff88ec0a1908ffe682da98dccf450adf9304287819e65f6ce44"
    sha256 cellar: :any,                 monterey:       "b51e2f7088f17a2387b3de37a002b6a9fc3f3ad3563d2f609d261745ffd510b3"
    sha256 cellar: :any,                 big_sur:        "c1b8e522004c71238b062b9c2dd703a5dc8de703588bb6283511a80ba511464a"
    sha256 cellar: :any,                 catalina:       "82686d1b93e1dd6c9fd203bb86fdd03a623777db13086166a3143adfd0e355f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dcb2de4cc3deb6bb09a27cf0458f830ab951f4a02f02908a646e46c7d907c99"
  end

  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    sysroot = "SYSROOT=#{MacOS.sdk_path}/usr" if OS.mac?
    system "make", *sysroot, "install", "PREFIX=#{prefix}", "RELEASE=1", "V=1"
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

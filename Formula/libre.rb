class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "f2b807f6d4cd0ff73e8233d44f81727c013160c0b39b528b056c2d2f93a8fa27"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "aa4dbc36738ce82ed6e91cd77406561830f4dae19b8e7b78e4386c0a186d7ea6"
    sha256 cellar: :any,                 arm64_big_sur:  "d4df50164520a7e0719b4966fc9b03f56cab24eb690be348dbff997f453b34c0"
    sha256 cellar: :any,                 monterey:       "0b125d515d560f8fea33a3c8f971ee814c1aa60016b549ba82a2f8c0a55438e1"
    sha256 cellar: :any,                 big_sur:        "4f4f2d4306780227fa8dae00e79822db56b76cee4d8634cf29155617831f29d6"
    sha256 cellar: :any,                 catalina:       "d32a9749b10b3cb069bf141daaed0070360bc385a14c92a228f99be3cf4b9615"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f3f51ef121a2c0b1116e96725e1b9daa9caa58d6109b77d896f33779c4e0758"
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

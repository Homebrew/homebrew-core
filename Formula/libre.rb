class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "665c9de5181d4c193d667e99aa23d9c9303e0ee458e97e93806a5a5eb49a2d81"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "45b366390f5f9ab4212cfb4e09eb1dda47e5a185a9d56396f7936bd36eb311c4"
    sha256 cellar: :any,                 arm64_big_sur:  "7887639a9d19860ed5610d512d3412abd30f8f4b7bec56d0e5b4cac0389456a7"
    sha256 cellar: :any,                 monterey:       "8b6f7250c6dbd43471961c8ab50874427e8b0dab8d062f6691b7767d21840d69"
    sha256 cellar: :any,                 big_sur:        "cd322c026f20d3609b0fc56c2ab61d3edf20d48c171d57291ec1a62e6a475bd0"
    sha256 cellar: :any,                 catalina:       "5bf146f16f0311e66b1c3ee7843349374305ac46beabebfe9ff9b0f6fe37ac47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02e8a406f27f397397f717cfcb2e2d7fbe3a4c3762dd0c2d761d76ba8738fea7"
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

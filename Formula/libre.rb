class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "6aa9622bc0fee6881770e0b374161df44edb395b5d295fc8c56e7b6fa18a8ea2"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bac916b886e39d113c21ca578761facc966856b72f5ec9cc149b37dc63745f8d"
    sha256 cellar: :any,                 arm64_big_sur:  "cae2a3cd54f43f1a23448f5aed1210265ff1adad2230013637d0381ce917269d"
    sha256 cellar: :any,                 monterey:       "d03f0bc83a993c1528a195dafaa81a64b9a705fb8f7f5ac576dffe69c689f45f"
    sha256 cellar: :any,                 big_sur:        "c5ce77e068720c102f8be7e684201ec140a25fbcf7991115adb382236c07ad2a"
    sha256 cellar: :any,                 catalina:       "0cbefd50aebad825a9cb3deb7655ed25c8f7c781a578c562f444cfdc54044532"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf8dffd8fee03d495acb8098720106624f39e2f79de16f81b0cba4ac1f1f5788"
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

class Libwpe < Formula
  desc "General-purpose library for WPE WebKit"
  homepage "https://wpewebkit.org/"
  url "https://github.com/WebPlatformForEmbedded/libwpe/releases/download/1.16.2/libwpe-1.16.2.tar.xz"
  sha256 "960bdd11c3f2cf5bd91569603ed6d2aa42fd4000ed7cac930a804eac367888d7"
  license "BSD-2-Clause"
  head "https://github.com/WebPlatformForEmbedded/libwpe.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_linux:  "21430cbe282f3c972c7816b2694042bbbe05817410119e62ecbceacb984d4586"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a306319524cd2e8d329c387f4f62bf4bc8511c5dd6f58527911c6560f2109ce4"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "libxkbcommon"
  depends_on :linux
  depends_on "mesa"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"wpe-test.c").write <<~C
      #include "wpe/wpe.h"
      #include <stdio.h>
      int main() {
        printf("%u.%u.%u", wpe_get_major_version(), wpe_get_minor_version(), wpe_get_micro_version());
      }
    C
    ENV.append_to_cflags "-I#{include}/wpe-1.0"
    ENV.append "LDFLAGS", "-L#{lib}"
    ENV.append "LDLIBS", "-lwpe-1.0"
    system "make", "wpe-test"
    assert_equal version.to_s, shell_output("./wpe-test")
  end
end

class Libwpe < Formula
  desc "General-purpose library for WPE WebKit"
  homepage "https://wpewebkit.org/"
  url "https://github.com/WebPlatformForEmbedded/libwpe/releases/download/1.14.2/libwpe-1.14.2.tar.xz"
  sha256 "8ae38022c50cb340c96fdbee1217f1e46ab57fbc1c8ba98142565abbedbe22ef"
  license "BSD-2-Clause"
  head "https://github.com/WebPlatformForEmbedded/libwpe.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5ed609989f08deb87a250e42f186999d2c995d6526309c0f79c64550686fbbdc"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "libxkbcommon"
  depends_on :linux
  depends_on "mesa"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"wpe-test.c").write <<~EOS
      #include "wpe/wpe.h"
      #include <stdio.h>
      int main() {
        printf("%u.%u.%u", wpe_get_major_version(), wpe_get_minor_version(), wpe_get_micro_version());
      }
    EOS
    ENV.append_to_cflags "-I#{include}/wpe-1.0"
    ENV.append "LDFLAGS", "-L#{lib}"
    ENV.append "LDLIBS", "-lwpe-1.0"
    system "make", "wpe-test"
    assert_equal version.to_s, shell_output("./wpe-test")
  end
end

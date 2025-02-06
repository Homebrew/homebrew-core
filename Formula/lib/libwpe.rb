class Libwpe < Formula
  desc "General-purpose library for WPE WebKit"
  homepage "https://wpewebkit.org/"
  url "https://github.com/WebPlatformForEmbedded/libwpe/releases/download/1.16.1/libwpe-1.16.1.tar.xz"
  sha256 "9cca60f2c4393ea0de53c675ebc3cdbe9c5aa249259dd1d6d81a49b052d37481"
  license "BSD-2-Clause"
  head "https://github.com/WebPlatformForEmbedded/libwpe.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e01b8a42552149efe9906c1b281ae2ed01a4a2aab6f5017c7a0357f9b7251d58"
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

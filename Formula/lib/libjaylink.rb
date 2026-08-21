class Libjaylink < Formula
  desc "Provide interoperability with JLINK hardware"
  homepage "https://gitlab.zapb.de/libjaylink/libjaylink"
  url "https://gitlab.zapb.de/libjaylink/libjaylink/-/archive/0.4.0/libjaylink-0.4.0.tar.bz2"
  sha256 "492da550fe1093a9b2d958304deb386380abea13ef7ce694b2ef68bfdaec664d"
  license "GPL-2.0-or-later"
  head "https://gitlab.zapb.de/libjaylink/libjaylink.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1b0d3f43054260068d75fe91f319341cd5889acc74f32a8e3b8f02e416023079"
    sha256 cellar: :any, arm64_sequoia: "f5507c214aab5d0b41d0a38853b8de5391e2ffd8099519f05736e1e4292f9131"
    sha256 cellar: :any, arm64_sonoma:  "7d11abee33f0afb168307e5d9870d5190ea7fe02aaf6a0013a44b2c77bacb447"
    sha256 cellar: :any, sonoma:        "a4f3ab5d3da9182cfd98eb9bcb3993a529bba5bab9608e44fe17d0efee0d6c45"
    sha256               arm64_linux:   "96f0b0dace9137e125de316598366cc47c10705c641a8bb1f0e0b0b94760a9ad"
    sha256               x86_64_linux:  "a4811f0e7c8cf0d76c8e3e9b871af22bb272bebe6170c280db26de657832df9a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "libusb"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~CSRC
      #include <stdio.h>
      #include "libjaylink/libjaylink.h"

      int main(void)
      {
        printf("%d.%d.%d",
               jaylink_version_package_get_major(),
               jaylink_version_package_get_minor(),
               jaylink_version_package_get_micro());
        return 0;
      }
    CSRC
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ljaylink", "-o", "test"
    system "./test"
  end
end

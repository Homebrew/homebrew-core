class Libjaylink < Formula
  desc "Provide interoperability with JLINK hardware"
  homepage "https://gitlab.zapb.de/libjaylink/libjaylink"
  url "https://gitlab.zapb.de/libjaylink/libjaylink/-/archive/0.5.0/libjaylink-0.5.0.tar.bz2"
  sha256 "6c03a9c4d9d781c41ca0f5203e46bebe47ecd5857c6a7d75cbc52accc7be73f8"
  license "GPL-2.0-or-later"
  head "https://gitlab.zapb.de/libjaylink/libjaylink.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a91a9b57c5081e9186378952e4955b41f7e11ad80714ca8c92fe69d6af281a92"
    sha256 cellar: :any, arm64_tahoe:       "8e3586f298a475f8d9991d9224d5c1182cc3fd93632f309d6350c1da189dfe22"
    sha256 cellar: :any, arm64_sequoia:     "06d29040f6a0484cda1d317d23a1f89507dc665060d41f6363a894c3601ae0e9"
    sha256 cellar: :any, arm64_sonoma:      "91697f046621a9133a0157bec85e027b2c950ed42f488821049b086a5332f697"
    sha256 cellar: :any, arm64_linux:       "7502574577d33de923e5295b8910537f06a09c98abadfaf2000eda61cdffda2b"
    sha256 cellar: :any, x86_64_linux:      "c90a0fb93a281015e512488d7f88bb77bf31a85df8226e76a583ef2490a2f9d7"
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

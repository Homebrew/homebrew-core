class Libmapper < Formula
  desc "Distributed system for media control mapping"
  homepage "http://www.libmapper.org"
  url "https://github.com/libmapper/libmapper/releases/download/2.5.2/libmapper-2.5.2.tar.gz"
  sha256 "aff1aa623eada922a428b730dacbe9523016600d1db9a9a53212833a6bd31ddc"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eebd88eb97dd64c5e05b8f19adbb3cb69a47fe99993f39007b3f812580e5f8e3"
    sha256 cellar: :any,                 arm64_sequoia: "82d939b92a88017d0a579d916f0f35a10ed9d0c5df4bcb2cbf04f0622bf9ac2e"
    sha256 cellar: :any,                 arm64_sonoma:  "bd99ce2671baa099d735a048187d541e2cdc4104f5fa0e705d767d8563031212"
    sha256 cellar: :any,                 sonoma:        "b602930e4d2ffc1950c9b947f8bae65bc6f769ba5eb0d5bfa58403d4dcd2f38c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f864aea23dafa21f4226ab0e2695fd5165e54af46892f164eff4fe5309f9af59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55c64edc6dadf0ad8f870a78960aa9b58c3d7f3a88f85249ce0d0f1da844d46d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "liblo"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include "mapper/mapper.h"
      int main() {
        printf("%s", mpr_get_version());
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lmapper", "-o", "test"
    assert_match version.to_s, shell_output("./test")
  end
end

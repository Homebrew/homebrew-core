class Libmapper < Formula
  desc "Distributed system for media control mapping"
  homepage "http://www.libmapper.org"
  url "https://github.com/libmapper/libmapper/releases/download/2.4.13/libmapper-2.4.13.tar.gz"
  sha256 "63ac6dd0ab5d17a9ec16f700665a6593a13667dd9fbc0f06df7f2f26d427defa"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c8d007e6c0d2e7efb0c8a4241a04c66294efeb33e43e1c9d5b92af69d5eb8075"
    sha256 cellar: :any,                 arm64_sonoma:  "be189c480f4350519834a307f654bc3dfc0c9581205add371a3c56ba8be7792d"
    sha256 cellar: :any,                 arm64_ventura: "64b6a17e57ccfb107db15abdd59a7bf1bbd1a4f656f9b8301677786c9564f6ff"
    sha256 cellar: :any,                 sonoma:        "d840f004b8216a9241755f6661e77fbd883eb80d8821e0cec80b92edd26c354e"
    sha256 cellar: :any,                 ventura:       "8da31eb36dda5ba63dbb01111cac4347fb966648cd6820073efea0c1fb3f029c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b230d96250aec983eabd700b21184f730a79313feace8453ebbee379ffec1bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7fc5bb105d25a71ab4d2010230a93e14c9f2d2b429846c1e3d49b9be969242d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "liblo"

  uses_from_macos "zlib"

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

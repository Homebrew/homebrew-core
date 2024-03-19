class Libmapper < Formula
  desc "Distributed system for media control mapping"
  homepage "http://www.libmapper.org"
  url "https://github.com/libmapper/libmapper/releases/download/2.4.6/libmapper-2.4.6.tar.gz"
  sha256 "ee08a02e0234599658fac2dd847a61c251ebcc1a49787f0e24afd8f09ba7ca61"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b2f2833c64dd7c92728443cedc89a20ae647c9018106bd3606838fc2c9f138ce"
    sha256 cellar: :any,                 arm64_ventura:  "57fa51a0a9acef324cf7ced073e2eba22b59e7ed12f433b39210210275934f9c"
    sha256 cellar: :any,                 arm64_monterey: "0e18fd483e5f755ed5eb0486d8fce8445f7c8079e7c9d3f00cb0ff866c3adf07"
    sha256 cellar: :any,                 sonoma:         "62aea0f692eea5415dca148065c7ed01700cf21bc8ff21cacf378d855e6fba50"
    sha256 cellar: :any,                 ventura:        "3cfab7e9a7f6383b24ec4f0b9166a586fd2d7d7a1bdebe65f4f2d95da8571df8"
    sha256 cellar: :any,                 monterey:       "2422beb08a446b2da732a3a6d13085790693c5445816f5ce1d0ab492f83dc890"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7f156dae5d18691ad2379aaf29507bd1ba98a1d9b672c58b1c3a81d28ee0240"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "liblo"

  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include "mapper/mapper.h"
      int main() {
        printf("%s", mpr_get_version());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lmapper", "-o", "test"
    assert_match version.to_s, shell_output("./test")
  end
end

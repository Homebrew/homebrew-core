class Libmapper < Formula
  desc "Distributed system for media control mapping"
  homepage "http://www.libmapper.org"
  url "https://github.com/libmapper/libmapper/releases/download/2.5.1/libmapper-2.5.1.tar.gz"
  sha256 "ce46ede6443b5c9c2d986d77e6eab901da4537394f14220f3102df2af7652495"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3c40391b0053a48a237a9958b2eb8a7bc556f1d53bd42d83682894d8a284fe5c"
    sha256 cellar: :any,                 arm64_sequoia: "243decca19fafb7401110a972fadbc46237c8ca1482ca508e8bdb2c167360a78"
    sha256 cellar: :any,                 arm64_sonoma:  "740c9c2d5e885e185319df50c6f3baa6f5525008eced450def3d50251ef590e6"
    sha256 cellar: :any,                 sonoma:        "7abd4912e21aade67e40b51b1bb5c9ab77c12871cdef5ac4cea9115415afbd6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb7b40032574927fec3dab98515547d5a1b7ce8c21708e70edb8629574b99690"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de57d036dca0a463b09a7041a0e1f9564556209c17ca100e96085964a3883a0f"
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

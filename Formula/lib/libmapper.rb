class Libmapper < Formula
  desc "Distributed system for media control mapping"
  homepage "http://www.libmapper.org"
  url "https://github.com/libmapper/libmapper/releases/download/2.6/libmapper-2.6.tar.gz"
  sha256 "4a9a0a1609f9ccacf822d9b063ea902fd21ba298c7cbf7f2a6c6908c35759669"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2c11132c8514c8c048b25474ac8828dbfb762774f68e7390f91274a70822ba5d"
    sha256 cellar: :any, arm64_sequoia: "0b78ba79fc587977d4f0ce033129f679fce617260bf2678f4f046ac113fe4e67"
    sha256 cellar: :any, arm64_sonoma:  "f0c5f56b353c1d6f9b2bc3b5d73d95fbf86ac1e6f9f9b4d6146112b90e9d9173"
    sha256 cellar: :any, sonoma:        "884bed710f859411122e077a8dabde76fb31b85d70a4ec79e5b6fef043f6613a"
    sha256 cellar: :any, arm64_linux:   "d7f7e273ecef9f05a6a303bf31d6c2774519d6ae6abba884d6d359fb16b9e375"
    sha256 cellar: :any, x86_64_linux:  "ab99038b6467e204e57d2aafe2d2881f673a1149f2937530c339a9a810820356"
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

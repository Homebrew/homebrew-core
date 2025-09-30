class Libmapper < Formula
  desc "Distributed system for media control mapping"
  homepage "http://www.libmapper.org"
  url "https://github.com/libmapper/libmapper/releases/download/2.4.14/libmapper-2.4.14.tar.gz"
  sha256 "b6b1ffbd3bec8eb7a73d9c70900f00284fcc242f83c1fdc390391a9059d4367a"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9cc0ffc210a4bdc777ccecc2f3d6557c9068801341b95e4bab834a1cb5c0de84"
    sha256 cellar: :any,                 arm64_sequoia: "f4b628b7551c6d4a1052cc7dab8d37e48ec1343e3c2947fdb87ac8407e042326"
    sha256 cellar: :any,                 arm64_sonoma:  "bd991c3b22f031ead73a425582228f175646172957eff5671d762d2a88197aa4"
    sha256 cellar: :any,                 sonoma:        "2b4b3afb52b575f600f3b15781e1b30372d1691c2e85b7f3cd4373f76d723fcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a921c84b89b5506fe3a799f8b55d42c40e3aceb1632ec8aacf634bea861f5a61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2991261b209aa1a21d24f68e570f7462c3bd4093a89dd8f2009b1e3a4ad69be6"
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

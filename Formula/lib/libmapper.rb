class Libmapper < Formula
  desc "Distributed system for media control mapping"
  homepage "http://www.libmapper.org"
  url "https://github.com/libmapper/libmapper/releases/download/2.5.1/libmapper-2.5.1.tar.gz"
  sha256 "ce46ede6443b5c9c2d986d77e6eab901da4537394f14220f3102df2af7652495"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "c18622efe48c4000baf732c9675a1c893d047dfb67c0b56294a822227d392de2"
    sha256 cellar: :any,                 arm64_sequoia: "801c922e7eac1db92bfd883855145d2e862895e877e19162a28e9b806eade6b4"
    sha256 cellar: :any,                 arm64_sonoma:  "3203a45d5d0c78d43b8f25991a603f76fc6a6cb8e84f0c12c81148c5211a49b3"
    sha256 cellar: :any,                 sonoma:        "68512b57f16cc4bf33a742933ccd4662d4a2a13800409101c67c940e81914ed2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38784f68909c9976766e5355ff92dcd38a2f197f8020480960b513a009fbabbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94bfc2ec392a9efdfab9212c6a3bd07de234278975daa884d49210b90ae276cd"
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

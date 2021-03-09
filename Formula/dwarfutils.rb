class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-20210305.tar.gz"
  sha256 "b86bef41725326d13ee3e7e45b929e0ca97b639e93cc1a9214c90a1774fa1c1a"
  license all_of: ["BSD-2-Clause", "LGPL-2.1-or-later", "GPL-2.0-or-later"]

  livecheck do
    url :homepage
    regex(%r{href=(?:["']?|.*?/)libdwarf[._-]v?(\d{6,8})\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "670691ddbab4d2fa1098fcb07f7b7831b26aba2101d2ea2ca270af8599b03dc8"
    sha256 cellar: :any_skip_relocation, catalina: "fb68efc4f5c05f989360c4b2d2c2b5b014aeb1de3e1c046c8ef5c45afcccafe6"
    sha256 cellar: :any_skip_relocation, mojave:   "57e5fefb572f7416d6410026d568709d6c91a51aa29c0c9c15025fba0dec0681"
  end

  depends_on "libelf" => :build

  uses_from_macos "zlib"

  def install
    system "./configure"
    system "make"

    bin.install "dwarfdump/dwarfdump"
    man1.install "dwarfdump/dwarfdump.1"
    lib.install "libdwarf/.libs/libdwarf.a"
    include.install "libdwarf/dwarf.h"
    include.install "libdwarf/libdwarf.h"
  end

  test do
    system "#{bin}/dwarfdump", "-V"

    (testpath/"test.c").write <<~EOS
      #include <dwarf.h>
      #include <libdwarf.h>
      #include <stdio.h>
      #include <string.h>

      int main(void) {
        const char *out = NULL;
        int res = dwarf_get_children_name(0, &out);

        if (res != DW_DLV_OK) {
          printf("Getting name failed\\n");
          return 1;
        }

        if (strcmp(out, "DW_children_no") != 0) {
          printf("Name did not match: %s\\n", out);
          return 1;
        }

        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-ldwarf", "-o", "test"
    system "./test"
  end
end

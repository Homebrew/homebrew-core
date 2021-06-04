class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-20210528.tar.gz"
  sha256 "b8ba0ee9b70d2052d45272489d79bf456c4d342fc8c3bba45038afc50ec6e28b"
  license all_of: ["BSD-2-Clause", "LGPL-2.1-or-later", "GPL-2.0-or-later"]

  livecheck do
    url :homepage
    regex(%r{href=(?:["']?|.*?/)libdwarf[._-]v?(\d{6,8})\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "feb9ab859e76e35cf9cb542c977f7699b7611494f0a7693b292292027820305a"
    sha256 cellar: :any_skip_relocation, big_sur:       "d87d517978e102343d43762c9272b995ff0e1501d3ae692231a276445c8da55c"
    sha256 cellar: :any_skip_relocation, catalina:      "168ffbfd98d2c026c607b1cdf4ae556e8fc0da70afc220c1d88ed2140c8592fe"
    sha256 cellar: :any_skip_relocation, mojave:        "f072dac053dee574c279956d1b072aeeb591a078d207d2d963a745e3553fab26"
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

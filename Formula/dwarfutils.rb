class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-20180809.tar.gz"
  sha256 "63e5947fbd8f342240d25bed2081251f8ec5428ee09e24dfad3b6956168bc400"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "576775907c6b337e738942d0f0151a7fc8be7b9e5291f4e595d563b8655d4880" => :catalina
    sha256 "8887f39199612129dcf7af5afc5bd473be806c74fd862ff2e76f3a5c06103f58" => :mojave
    sha256 "b31bc53474ac561e418ef6c81add9ccb8e885f8f744493971fae29fddc887f45" => :high_sierra
    sha256 "f2909fb054f392f80318f7d621124c6bd5aee4e8637ad2d26f350d8b645ec5ef" => :sierra
  end

  depends_on "libelf" => :build

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
    system ENV.cc, "-L#{lib}", "-I#{include}", "-ldwarf", "test.c", "-o", "test"
    system "./test"
  end
end

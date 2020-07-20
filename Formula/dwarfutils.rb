class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-20200719.tar.gz"
  sha256 "307d02b8f972de82c4b690a6e9852b66b6df0a23aa8d407430b6ee3d9ecbaccd"

  bottle do
    cellar :any_skip_relocation
    sha256 "2a318b2194aba43007299bed24723347a253287a865368f96be3c65095de454d" => :catalina
    sha256 "7999b912b1bcb90663c8c2c34bf583165da2243c95b8ae644ec52128ada5e6df" => :mojave
    sha256 "12c6d9e23aa3b8a7c2e439daba272054f442d52d549814b9f765c9433c8a0a83" => :high_sierra
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
    system ENV.cc, "-L#{lib}", "-I#{include}", "-ldwarf", "test.c", "-o", "test"
    system "./test"
  end
end

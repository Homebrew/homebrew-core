class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-20200825.tar.gz"
  sha256 "c42786a085bf244c8a1b0238b57f42f6cfc582baebe5e174ea62eb1a81f32103"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc36e7fc39f73723520c29f823c11c62a45c0412db6cd5360291c4f0f8e4018c" => :catalina
    sha256 "68c897651d6a0c7e1d08459e4361c8d22ff465bd83d0be6bf0e4864ab30e1133" => :mojave
    sha256 "7d99f3f2173938d512b5268fc0d94f36a0915dc040fdaa9a08ae0448166ab8fc" => :high_sierra
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

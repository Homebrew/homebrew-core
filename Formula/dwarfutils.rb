class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-20200825.tar.gz"
  sha256 "c42786a085bf244c8a1b0238b57f42f6cfc582baebe5e174ea62eb1a81f32103"

  livecheck do
    url :homepage
    regex(%r{href=(?:["']?|.*?/)libdwarf[._-]v?(\d{6,8})\.t}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e0327be931c95af4ec48f26ea7074b845a22519fb5b77d85a4d998f5eb41a9b8" => :catalina
    sha256 "137d8e78ad93146c117ac0d54b400f482e5e7f77715da38f9dd706fe13f1a911" => :mojave
    sha256 "a1a67921310eee29917097960b09f75d12043544c460ad678f3f0febe66c0ecb" => :high_sierra
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

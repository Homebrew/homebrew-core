class Dwarfutils < Formula
  desc "lib and utility to dump and produce DWARF debug info in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-20161124.tar.gz"
  sha256 "bd3d6dc7da0509876fb95b8681f165febd898845dc66714aa58e69b8feca988f"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f438c3cd34530354e60623a7b08a28400e73f0527f3f0b91c839bd9fcf78b5a" => :sierra
    sha256 "d60842f5bfe921d6fc7eb649302262544c3ab4fda5d1699ea8e69c5cafe695f9" => :el_capitan
    sha256 "aeeda0cfd7fc1ce9400a6c368d02a12eb42c5859e8a11a84e38e3add9879878f" => :yosemite
  end

  option "with-sanitize", "Use -fsanitize"

  depends_on "libelf" => :build
  depends_on "gcc" if build.with? "sanitize"

  def install
    args = ""

    if build.with? "sanitize"
      ENV["CC"] = "#{Formula["gcc"].bin}/gcc-6"
      args << "--enable-sanitize"
    end

    system "./configure", args
    system "make"

    bin.install "dwarfdump/dwarfdump"
    man1.install "dwarfdump/dwarfdump.1"
    lib.install "libdwarf/libdwarf.a"
    include.install "libdwarf/dwarf.h"
    include.install "libdwarf/libdwarf.h"
  end

  test do
    system "#{bin}/dwarfdump", "-V"

    (testpath/"test.c").write <<-EOS.undent
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

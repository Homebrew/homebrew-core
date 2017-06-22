class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-20161124.tar.gz"
  sha256 "bd3d6dc7da0509876fb95b8681f165febd898845dc66714aa58e69b8feca988f"

  bottle do
    cellar :any_skip_relocation
    sha256 "1cfcd1316ed75c66db70f5aa450d9808de5be9535e6b99fef6b2c81374d6274d" => :sierra
    sha256 "9f22aea1978e9f3df7f2aaf2475341e9d901ded7f58a6cc75458d6b497e4c32d" => :el_capitan
    sha256 "da3a66a5b440cd42329c5f2e1729657328d9cdae0a8e4306142748de4c25b42e" => :yosemite
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

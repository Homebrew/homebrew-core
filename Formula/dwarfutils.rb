class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-20180809.tar.gz"
  sha256 "63e5947fbd8f342240d25bed2081251f8ec5428ee09e24dfad3b6956168bc400"

  bottle do
    cellar :any_skip_relocation
    sha256 "460aaec0bbc38105f125ff69012f46eaba845dea080fdcd88ba8e6c0a5789663" => :mojave
    sha256 "82361d153cd6047be2ca344f053cd96eed1afbd167cdb791660e8353123cca04" => :high_sierra
    sha256 "ff56b762211461a273b6023c3c38cb4be36bbb2696894ac928cdc7b329bc3064" => :sierra
    sha256 "5a9553cc6bccfcd519a04b7fe05c9bb6150553893cef274b11c1acf16ea5d555" => :el_capitan
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

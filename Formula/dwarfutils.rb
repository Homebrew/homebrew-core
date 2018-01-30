class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-20180129.tar.gz"
  sha256 "8bd91b57064b0c14ade5a009d3a1ce819f1b6ec0e189fc876eb8f42a8720d8a6"

  bottle do
    cellar :any_skip_relocation
    sha256 "a094f5785e8feb015608a4acdcf7f5ae00424adc3da04792581dc7ddbeea7e7a" => :high_sierra
    sha256 "6be17e49a4a3e34c81a4c034a671db42bd53013bf9194c5ff8de4c0e91588292" => :sierra
    sha256 "563dad4f509d2f1aa1f7d6b222614864c42dcb986d6bdc1fe7a094f952b55a9a" => :el_capitan
    sha256 "99b4b4822bf18f7a6ce085a48cdf3116e27610117a64e18c4040a96a1929973d" => :yosemite
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

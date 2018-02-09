class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-20180129.tar.gz"
  sha256 "8bd91b57064b0c14ade5a009d3a1ce819f1b6ec0e189fc876eb8f42a8720d8a6"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f818559afe85bd41eb7e96c273b3e8f4d68afa4aea28ad9c28a9461595eb077" => :high_sierra
    sha256 "092c2d5cb68c6644d312e7b7b365e926e9353dfd196d7680fdf5cbadb1406f9e" => :sierra
    sha256 "0769a3da91dead3364d833cb9caa602f36bfc4b2b5ed8e0c9fb7d7ef93fb52a2" => :el_capitan
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

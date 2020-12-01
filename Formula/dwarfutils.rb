class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-20201201.tar.gz"
  sha256 "62db1028dfd8fd877d01ae75873ac1fe311437012ef48a0ac4157189e1e9b2c9"

  livecheck do
    url :homepage
    regex(%r{href=(?:["']?|.*?/)libdwarf[._-]v?(\d{6,8})\.t}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3f38cc1aefc659c6acf1ba09ff229b71f31cbbe1ac8928c164ad05895c202eff" => :big_sur
    sha256 "1b9a9f2aaae5e305ff265839fe0f71e709814c8c9f0249dc3410b6cac702cadd" => :catalina
    sha256 "1640ed20f01ce164951d84ae103e797c11545e6aee99fa27eb20335abe38a288" => :mojave
    sha256 "da07cd4af006c48927a261cce0377289ff738f3d7cf12adf4f7ecb390a01a66d" => :high_sierra
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

class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-0.1.1.tar.xz"
  sha256 "cf0c82346c4085ea911954d80385fbdfa0d536e61975343416cad4c4308738f3"
  license all_of: ["BSD-2-Clause", "LGPL-2.1-or-later", "GPL-2.0-or-later"]
  version_scheme 1

  livecheck do
    url :homepage
    regex(%r{href=(?:["']?|.*?/)libdwarf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "feb9ab859e76e35cf9cb542c977f7699b7611494f0a7693b292292027820305a"
    sha256 cellar: :any_skip_relocation, big_sur:       "d87d517978e102343d43762c9272b995ff0e1501d3ae692231a276445c8da55c"
    sha256 cellar: :any_skip_relocation, catalina:      "168ffbfd98d2c026c607b1cdf4ae556e8fc0da70afc220c1d88ed2140c8592fe"
    sha256 cellar: :any_skip_relocation, mojave:        "f072dac053dee574c279956d1b072aeeb591a078d207d2d963a745e3553fab26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9646e9356c7b30e464afbec046633bd985d0f3a97609ae56606321d965f7686f"
  end

  head do
    url "https://github.com/davea42/libdwarf-code.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  uses_from_macos "zlib"

  def install
    system "sh", "autogen.sh" if build.head?
    system "./configure", *std_configure_args, "--enable-shared"
    system "make", "install"
  end

  test do
    system bin/"dwarfdump", "-V"

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
    system ENV.cc, "-I#{include}/libdwarf-0", "test.c", "-L#{lib}", "-ldwarf", "-o", "test"
    system "./test"
  end
end

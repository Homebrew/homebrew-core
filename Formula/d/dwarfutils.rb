class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-0.9.2.tar.xz"
  sha256 "22b66d06831a76f6a062126cdcad3fcc58540b89a1acb23c99f8861f50999ec3"
  license all_of: ["BSD-2-Clause", "LGPL-2.1-or-later", "GPL-2.0-or-later"]
  version_scheme 1

  livecheck do
    url :homepage
    regex(%r{href=(?:["']?|.*?/)libdwarf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "689a4811e41e3dc2c15d64c8eb5117d9d2766d63e29c15c2e28ce2d812071dba"
    sha256 arm64_ventura:  "35a285b2581571e4bd18ae9ea61964da69e15f3fa5302bf7096dfb3257d307d5"
    sha256 arm64_monterey: "5687303c62e902a67e395388353b8b8c952136b19cb1d96d337da3674858b7a7"
    sha256 sonoma:         "a16533bd25bb25e3e023bf40dc0d736a4a88d67912936cec383646345a197263"
    sha256 ventura:        "7ae3196b2a94ba1606c183d6480db764f80f9dfd1ea44f5c948c2a8f796bec1c"
    sha256 monterey:       "fa5baf43f59ecb9481f58c893b2dda0fbd46b3c7f0c02803d0308bb09aefb6d3"
    sha256 x86_64_linux:   "73a16cbd1bf33f3dd0a4c181b918105e3f359f3ec4ad60d47c7f99cf443bd32e"
  end

  head do
    url "https://github.com/davea42/libdwarf-code.git", branch: "main"

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

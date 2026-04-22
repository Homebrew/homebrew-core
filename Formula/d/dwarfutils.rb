class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-2.3.1.tar.xz"
  sha256 "28cf9a5d27aceff5c1f906244a4fe7ae208e41d20a6d8fc7e091c633a40b6e97"
  license all_of: ["BSD-2-Clause", "LGPL-2.1-or-later", "GPL-2.0-or-later"]
  version_scheme 1
  compatibility_version 1

  livecheck do
    url :homepage
    regex(%r{href=(?:["']?|.*?/)libdwarf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "752d45b11e29fc78e90a43bfecf382d5f768da1a8569db2371f525ecdaff17d7"
    sha256 arm64_sequoia: "420bde41ae0491828e285f83bcbf188e9549b7894644676ecb2d6cba4f682ab4"
    sha256 arm64_sonoma:  "dba2f5985ebaf17b9354d2cee8a953c1c92cc2e6f73b3b0fcd28039905204e9d"
    sha256 sonoma:        "2c1ab11b0d78fd578ce781274973360f73438a07e9d9ed2dbd58e4415f9a677e"
    sha256 arm64_linux:   "e65661754f9b85f1de0ca278b5069e542b9f69ae2faeba7a2185a84c9077263f"
    sha256 x86_64_linux:  "248698403849ffe50c05d9144e79db13c71a66b4e6d5c54589e3e749c42a1fc5"
  end

  head do
    url "https://github.com/davea42/libdwarf-code.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "sh", "autogen.sh" if build.head?
    system "./configure", "--enable-shared", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"dwarfdump", "-V"

    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "-I#{include}/libdwarf-#{version.major}", "test.c", "-L#{lib}", "-ldwarf", "-o", "test"
    system "./test"
  end
end

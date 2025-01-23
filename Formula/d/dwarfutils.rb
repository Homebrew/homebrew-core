class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-0.11.1.tar.xz"
  sha256 "b5be211b1bd0c1ee41b871b543c73cbff5822f76994f6b160fc70d01d1b5a1bf"
  license all_of: ["BSD-2-Clause", "LGPL-2.1-or-later", "GPL-2.0-or-later"]
  version_scheme 1

  livecheck do
    url :homepage
    regex(%r{href=(?:["']?|.*?/)libdwarf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "2512f3599c17012df5dd2eadcda5272af06f3d1763c49bc53f2cbfae7bcf475b"
    sha256 arm64_sonoma:  "5583328bb0280f4273155b6fdf0c6a4f47e3cc8b6cb322e7bb1a6e77434a6e06"
    sha256 arm64_ventura: "c76a679482e874f69993afcc0977c9902195f05dab9c27943b53d6c666488d5d"
    sha256 sonoma:        "6465cb24d88a78309be0d57e915e4bded2e53be288ab470b6f57f5a7149557d1"
    sha256 ventura:       "c64584bbd209938f60b72fffe19abdc4105391f71496bafb951f970b6b238bdc"
    sha256 x86_64_linux:  "f32720e90c4ae83dacde105e2b06c5aa1fb9c82f5d79a7d1e57831276f45344a"
  end

  head do
    url "https://github.com/davea42/libdwarf-code.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build

  uses_from_macos "zlib"

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
    system ENV.cc, "-I#{include}/libdwarf-0", "test.c", "-L#{lib}", "-ldwarf", "-o", "test"
    system "./test"
  end
end

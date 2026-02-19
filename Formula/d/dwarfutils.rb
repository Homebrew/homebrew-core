class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-2.3.0.tar.xz"
  sha256 "a153e8101828a478f88d18341267b59c19a3fc794bea47388347ce994ba90c17"
  license all_of: ["BSD-2-Clause", "LGPL-2.1-or-later", "GPL-2.0-or-later"]
  version_scheme 1

  livecheck do
    url :homepage
    regex(%r{href=(?:["']?|.*?/)libdwarf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "012f02066b5f44638753efbf2ec992d15e290936bd1c7485334b186264cfae81"
    sha256 arm64_sequoia: "53215ad282ab0c349c0dde47a71d4fcb02e8179ab5c6c68213442ccbce33ca69"
    sha256 arm64_sonoma:  "c2366f349b9adde3b2d6d08cec22d8d37d58a6c5ce9937183ce510a147fb4322"
    sha256 sonoma:        "54eba622e99ccd12af000c6864ddda89f00ce403910897a9efed7ddf00b079f7"
    sha256 arm64_linux:   "1acb19e3453aeb75adcec1e343a4565634f80dc729c4c096645df36a3e484144"
    sha256 x86_64_linux:  "8cb209d80473cbaef21e8009b244fd0e655b13a9c312a7fe978b7d2946a82e3f"
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

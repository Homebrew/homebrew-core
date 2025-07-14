class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-2.0.0.tar.xz"
  sha256 "c3d1db72a979e14ee60b93010f0698d30fc1bca4eb1341006783d4e9c9ec7e72"
  license all_of: ["BSD-2-Clause", "LGPL-2.1-or-later", "GPL-2.0-or-later"]
  version_scheme 1

  livecheck do
    url :homepage
    regex(%r{href=(?:["']?|.*?/)libdwarf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "8a93bf3ca4c73958208238cc173242a6bc99025cd5adadecd697b4f971ba3620"
    sha256 arm64_sonoma:  "151e51424ec0a8bb569eae5f73ca095e3e48f1f35ba47ef854f92cd2cf98215c"
    sha256 arm64_ventura: "569083ceb799841e0bc113b880c3fa97cda3811f1655058964c858c1ea539ac5"
    sha256 sonoma:        "38f42780706c79196f5748da644307d4efa3045c2cd74a6520ab4d0165e07356"
    sha256 ventura:       "bf872ada49472754106bf71c5d1ee67060c0916fdb9d94b7e3fd0dc3ca0dbf36"
    sha256 arm64_linux:   "2c5ba2d4472cf762f60649926cff39012870e879af487b081135813e9b175c97"
    sha256 x86_64_linux:  "c1d6c7ee546346820e48a929387c395756b10473eed84ca4d8ead8d53242d483"
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
    system ENV.cc, "-I#{include}/libdwarf-#{version.major}", "test.c", "-L#{lib}", "-ldwarf", "-o", "test"
    system "./test"
  end
end

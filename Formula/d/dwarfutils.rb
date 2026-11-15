class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-2.3.3.tar.xz"
  sha256 "bde13d1c49be6f2467326a6e0b3919247471455d16eefc3c6be26c7d4baca36a"
  license all_of: ["BSD-2-Clause", "LGPL-2.1-or-later", "GPL-2.0-or-later"]
  version_scheme 1
  compatibility_version 1

  livecheck do
    url :homepage
    regex(%r{href=(?:["']?|.*?/)libdwarf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_golden_gate: "ae1e174d0c3e6b044ab2dad4fe7bb89585d6f725dd641c7d82bff80e20018d6f"
    sha256 arm64_tahoe:       "e8615a85ebe4b24f3a14dc93c8d8b7b52520d812f05466e186c9cb4d4db7b8a6"
    sha256 arm64_sequoia:     "a91d9cadb172a23300b9e1fb1db1eec35fc3886991f6f1dda0ac8812cfcc5f38"
    sha256 arm64_linux:       "fed704faa7887461be1f593a77efb23422543187f8d1c799088293d3db7d01fb"
    sha256 x86_64_linux:      "b22dc3476addbfc3d5dfbd7d8002de65d4cd9e525b6a26a2bab1c2c9839dacc1"
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

  deny_network_access!

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

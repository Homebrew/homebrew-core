class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-0.9.1.tar.xz"
  sha256 "877e81b189edbb075e3e086f6593457d8353d4df09b02e69f3c0c8aa19b51bf4"
  license all_of: ["BSD-2-Clause", "LGPL-2.1-or-later", "GPL-2.0-or-later"]
  version_scheme 1

  livecheck do
    url :homepage
    regex(%r{href=(?:["']?|.*?/)libdwarf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "5aaf16647266817f201e22d6845657353c69b89d92d78b4ff0cad5708cb123a4"
    sha256 arm64_ventura:  "7485040808b9700297168b9d76226e9a9c32cafc76df20274d311db21b3b424a"
    sha256 arm64_monterey: "49274eff4d1f9782d24ff29e6a53b6e5f498b7c2614e3e937093dc66cc54b541"
    sha256 sonoma:         "fcc3aeacd34156ba3b768ddffce8c7b0cabd44efb78a049909de75950c3807a8"
    sha256 ventura:        "14afe15542d14c33c0e58cbe948cc684fd6d44f2a9dde9d98f22c07e174210de"
    sha256 monterey:       "28fd7a2935109578b97f0f69fbe1546ee88ca17686401645bc19e7a30b405df5"
    sha256 x86_64_linux:   "391c6c7928b215ed1cc947609614450b55374444940640a57e6827dd698dc9b9"
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

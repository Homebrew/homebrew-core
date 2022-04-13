class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-0.4.0.tar.xz"
  sha256 "2cb065faa323b02f836a858ce62d2b9efa11ecd0f6e8b1133fdab5ae9318e198"
  license all_of: ["BSD-2-Clause", "LGPL-2.1-or-later", "GPL-2.0-or-later"]
  version_scheme 1

  livecheck do
    url :homepage
    regex(%r{href=(?:["']?|.*?/)libdwarf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "8200455d69d5c43e2cd7102188f740bddca5f152b1ce63e9902dfc8db1e5e96f"
    sha256 arm64_big_sur:  "3ee84d60c463ab026a1cc02771919ff450c27d2018fe92dab4d0add73e6bc04f"
    sha256 monterey:       "b6fb057953ce211ee14fb768720696a10ce7787cb3d2c1908847e198b098aa9a"
    sha256 big_sur:        "dc028aab59c446143e1b91a72c42a44bff6caaef73a2c491b759245a6850cc83"
    sha256 catalina:       "77ec113fae6b92574866c705ec37a6d5ff5a121b531cc2c981e4d921bac6f24e"
    sha256 x86_64_linux:   "c38c27f699e4238e72c60b12f8f08743c127adc4d00e80d2a151a027f4886c67"
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

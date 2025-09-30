class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-2.1.0.tar.xz"
  sha256 "461bd29cbb9a41c26a25b0e527c3736c772bb7a89f6260d1edb39ab105226e06"
  license all_of: ["BSD-2-Clause", "LGPL-2.1-or-later", "GPL-2.0-or-later"]
  version_scheme 1

  livecheck do
    url :homepage
    regex(%r{href=(?:["']?|.*?/)libdwarf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "1afe40a7c19dc56087012ac8b931ae71cbda2797c389ff3430df80a81153d5a2"
    sha256 arm64_sequoia: "143b1cf7befda30f5980aa7c6a81e92b627ce61db77af36bb2e3120a0b225380"
    sha256 arm64_sonoma:  "1ca05e626afa92045007109d01e70bbc36bb75a08b2f5aab2ea2c7f9e06bd803"
    sha256 arm64_ventura: "56c44d3750de55a820cf5542e7d9c1638eba2373c95d1b40544e7858cb873eb0"
    sha256 sonoma:        "ee109538a120b0596720fc0b0dbb412d933c75b1e5cac98b49f11f51d44b157a"
    sha256 ventura:       "6cdd6745c5db9769ce9b4e21348ec901b65525e245a2b602f77fa912eaf19cdc"
    sha256 arm64_linux:   "0c33e5c78956abd5215d30bd0615351772608b651cb8391ae1505374e7bfba5f"
    sha256 x86_64_linux:  "f092926133247cd6008dcab1884c90ac194d1719f945fe9d2202aab25af8d42d"
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

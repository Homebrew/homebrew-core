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
    sha256 arm64_big_sur: "dd08048594fd7f0bfdc02ed06c6c4e44ed4c75eeb8cdcc2adb490036e07f3f4e"
    sha256 big_sur:       "84941130062830cdf8bb7e724d38704df8fa27cc90a19db76326b391d8c1049b"
    sha256 catalina:      "1664a1d0bfadf1ee6fdb95229aeea41c7cddae537afa8bdaed398d99f31e8c4b"
    sha256 mojave:        "89f93e8814b05bfa901aa11a41526d86737f742b4cb150d9df5b0f241aa995fa"
    sha256 x86_64_linux:  "20d0af399420474afd8c5e3fb24c592aca8d37efbf0e93e49763c9bfcf8ff6fb"
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

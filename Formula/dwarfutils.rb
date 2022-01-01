class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://github.com/davea42/libdwarf-code/releases/download/libdwarf-0.3.2/libdwarf-0.3.2.tar.xz"
  sha256 "a5b150182a1ce18e16b2f4225d3902b3f2b30181d2678f29cbd90b5ee7b067d1"
  license all_of: ["BSD-2-Clause", "LGPL-2.1-or-later", "GPL-2.0-or-later"]
  version_scheme 1

  livecheck do
    url :stable
    regex(/^libdwarf[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "654dff0b2f82a4af9bdbc5fa5473f107e556d6d7a3caa0cee32ecc2628c2045f"
    sha256 arm64_big_sur:  "1ac707281f28a7be75c030222d7eb378f58db82040b309c0418f029134bb6186"
    sha256 monterey:       "80d4a8ffa93dabc301a08ab3aa8bdf8fdb0d17fa57ceb16455942388ae2eccab"
    sha256 big_sur:        "f913d232e750af922f3e0feb511cad52c474d439f5a8422a728e1b1d4ea01b62"
    sha256 catalina:       "c29eab047006707ab332ef2ca0bd45a99f9ffa75291913db1404ec097c93115a"
    sha256 x86_64_linux:   "64d095718fdca66995562b7b76ab9434d588d6c3c2d694773ebfef5517fe0a2f"
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

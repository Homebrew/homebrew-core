class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-0.3.3.tar.xz"
  sha256 "0b8f7cfdf4b2bd5e2a7f31986c8f066ab2a79e7bbdf52e6bad88252153c316fe"
  license all_of: ["BSD-2-Clause", "LGPL-2.1-or-later", "GPL-2.0-or-later"]
  version_scheme 1

  livecheck do
    url :homepage
    regex(%r{href=(?:["']?|.*?/)libdwarf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "ae7fb26b4743a69d996bcf3bfebdb73f1401122540657577111e3f2babd18701"
    sha256 arm64_big_sur:  "dbfe56dc55cb8c0d946b8c3b809446fe573c1ac844e8359bf11dc22ca655bd6f"
    sha256 monterey:       "5aeda5f1d334f73c3082bfea6f7f66223e720cd6b502dc1aa3d02300f39f5a3b"
    sha256 big_sur:        "994b22f8129311312ee35b7b3abfa899fad87323ea6b34d748a6153a02dbc51d"
    sha256 catalina:       "009a4208a514c1a28bdea6602e48f1b671c5d65df02d26190c1c52c1b2e3bf8f"
    sha256 x86_64_linux:   "cb27328b08f6c7596f042a866fa93b70612e77c9d82237ee3d407db90412eee4"
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

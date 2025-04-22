class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-0.12.0.tar.xz"
  sha256 "444dc1c5176f04d3ebc50341552a8b2ea6c334f8f1868a023a740ace0e6eae9f"
  license all_of: ["BSD-2-Clause", "LGPL-2.1-or-later", "GPL-2.0-or-later"]
  version_scheme 1

  livecheck do
    url :homepage
    regex(%r{href=(?:["']?|.*?/)libdwarf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "ec32537c7a568c917f5272456848661e30ce00ac9cf5fd4b68dc70d7316813c5"
    sha256 arm64_sonoma:  "c6be302ac2ebf8ef550362c794b703564f4ce039830f7c644f83429f03bb9229"
    sha256 arm64_ventura: "e96358f887b938d3f7253721e876c8ffa8941b1e32a31a8380d4df9cb4898e77"
    sha256 sonoma:        "c42720cbd7837861122a08219b26c3c8cce385f694f8e2282d7a438c549c8b83"
    sha256 ventura:       "467ea3e56e9a9f808469ec730d8894d59ec23f4b42e3a79cd48111c222fba34a"
    sha256 arm64_linux:   "0b7aaef94c972dab147ee440a9655daca11d2f7b8c6c684e40827769800f0312"
    sha256 x86_64_linux:  "5f9220def8c174b3b3635804e5694b525386f39f92acc189e4a45bc7316f761e"
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

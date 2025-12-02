class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-2.2.0.tar.xz"
  sha256 "54c0abbbeb4190bd1babb5d28574d2b20c2309343ec764cc7ca611e527ee4a42"
  license all_of: ["BSD-2-Clause", "LGPL-2.1-or-later", "GPL-2.0-or-later"]
  version_scheme 1

  livecheck do
    url :homepage
    regex(%r{href=(?:["']?|.*?/)libdwarf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "9f5c9bf451c55f21dbe328a470f479c91ef0c192e1df94be596ddcf03fde44e7"
    sha256 arm64_sequoia: "36b5f04f0a13b2a4acb4c81dca32d61e19463890fb724077dcde89d5f3b7c07e"
    sha256 arm64_sonoma:  "541f6c97138661d7a0d372b156be97395e9e3671e86917fb1632cee830259cc2"
    sha256 sonoma:        "2dd552d1906eeea1907b052b5d536c3017757dcd3e5ca24acb217101047f11fe"
    sha256 arm64_linux:   "b65972ad5560dfc19ed0e4666eae9fb942d4fc63df0744132e108da88173a29a"
    sha256 x86_64_linux:  "1d9676d26d59880c80fbe7d7c3983d40bc74a0a882205743942f46eba7a6eea3"
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

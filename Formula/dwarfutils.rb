class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-0.4.1.tar.xz"
  sha256 "34277b969d30be3cc4c6fbce6926dd3e6f9ea9a27b01951c6753b479aadfd5ef"
  license all_of: ["BSD-2-Clause", "LGPL-2.1-or-later", "GPL-2.0-or-later"]
  version_scheme 1

  livecheck do
    url :homepage
    regex(%r{href=(?:["']?|.*?/)libdwarf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "e98898849c8ed8d409553705848720cb67bb594476a2fe19449c816b2ce9b678"
    sha256 arm64_big_sur:  "38d064fe9cdd6959ad7f014e5f9059b8557c1d8c5f0e43a7c9b33ec0f5d363dd"
    sha256 monterey:       "5d889c894abdc10461cb501d786e53b3d95b8b18f7fd5ae540a869203a69f702"
    sha256 big_sur:        "9f9fd6c83fdde2338b9825de80841afbf4048326efcc4070bbe030d9aacd9219"
    sha256 catalina:       "bcd83b33054908b6275c71cd9c219cea98c37c0d0c283554402222600a680078"
    sha256 x86_64_linux:   "1f0b6b0b0f4d9ed34013614349a8b55291f369aa6e5c5c09076316c53b6b1254"
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

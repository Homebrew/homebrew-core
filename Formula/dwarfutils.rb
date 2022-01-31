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
    sha256 arm64_monterey: "48018bf9047512453554212a3a8b99fc97fc4bde1aff269dcf562cd30de35b75"
    sha256 arm64_big_sur:  "94756b2b311f441c7715184b46020aea6fd0b47c6afed35d5db09619dda0913d"
    sha256 monterey:       "27fe2420fda361070449130318cb692ddbe5f74034bbd236a180397940e5ba53"
    sha256 big_sur:        "006d4cd68ccb278cdc527cd6853fafb3e58f661a1a3a084affe2a4ce0713d364"
    sha256 catalina:       "5b2ff7594ac522dc8bf2310a282d5dc3c94fd348475b8d7963b94e15b411f0ba"
    sha256 x86_64_linux:   "3337b95be727be11daa87123495b656167b9b0f8eadb028bbd88a1a14c5426e6"
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

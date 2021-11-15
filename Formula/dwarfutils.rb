class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-0.3.0.tar.xz"
  sha256 "dbf4ab40bfe83787e4648ce14a734ba8b2fd4be57e781e6f5a0314d3ed19c9fe"
  license all_of: ["BSD-2-Clause", "LGPL-2.1-or-later", "GPL-2.0-or-later"]
  version_scheme 1

  livecheck do
    url :homepage
    regex(%r{href=(?:["']?|.*?/)libdwarf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "d6cff3c0d45ad78f808816cc997746e031e9ec58b7407d6d9a568ea88f11f3f8"
    sha256 arm64_big_sur:  "a512b84f3ca4cf012ffb5b44322293e7e8f186f0306b036c8ece6d8379421bc2"
    sha256 monterey:       "27cb1e7acce8198b9aa50d7afcf52f33756a20ff8f0d9be28872a306f172f722"
    sha256 big_sur:        "7eae9663f303a5337a1cf712853c2a0d8be355cb3ba7d05039d71748fa6e9a76"
    sha256 catalina:       "d867a96247815c582f7ba01e5d9e37e5e5c035e2656c166a68d64134e488d6c2"
    sha256 x86_64_linux:   "21145b8d188ba8863b4deb222df36e076c7a642bc13fa9d869e1db654ff2cc89"
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

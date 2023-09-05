class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-0.7.0.tar.xz"
  sha256 "23b71829de875fa5842e49f232c8ee1a5043805749738bc61424d9abc1189f38"
  license all_of: ["BSD-2-Clause", "LGPL-2.1-or-later", "GPL-2.0-or-later"]
  version_scheme 1

  livecheck do
    url :homepage
    regex(%r{href=(?:["']?|.*?/)libdwarf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "351b5e4f9bd4c051236e8e0218aec409c0ba7b77177c8f7d2cc71e8ede9bee14"
    sha256 arm64_monterey: "d497ea347dbd38f740ca0039eb4d67956d8a557eb436cc764b197aabb7dd2446"
    sha256 arm64_big_sur:  "af5029b2bed4d9f8ca6ff0701cc167fec08e816704cf5b6ff33f9e57a930cb99"
    sha256 ventura:        "1aaa83cdade985bf174f8be6c8e24bf852c9ddc1943984d6aa0ba128d52ec046"
    sha256 monterey:       "20002110ce2b3fa93b74cfe40619ffc0bcbdf1f8246cf480e9d100ce0d8f7f93"
    sha256 big_sur:        "a2ffdfa558dded506459cb28e64422b2d63863a38bba572329bc2af7d8f91748"
    sha256 x86_64_linux:   "f6aa1ee70893b818d2adfa07bda997bf23b11490a0cdd0cb73acecc9e5a2bfbb"
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

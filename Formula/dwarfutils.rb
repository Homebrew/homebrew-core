class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-0.4.2.tar.xz"
  sha256 "c4369b6d9a929cb9e206f0cd65c325e76bbd1e66d49da19da5e7bc0cb8e6841a"
  license all_of: ["BSD-2-Clause", "LGPL-2.1-or-later", "GPL-2.0-or-later"]
  version_scheme 1

  livecheck do
    url :homepage
    regex(%r{href=(?:["']?|.*?/)libdwarf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "1162ae0f3802ec6a69906802f0bd39350320d98b3ecbc26599fe7b5f9fc45e54"
    sha256 arm64_monterey: "c809b3968af17d21341d29e067bf9d5bb75d148828f17fcd47c6ea90eaebe0da"
    sha256 arm64_big_sur:  "61774aa3d47a48235a39742d166d1a30c5ee55ebe2cbe9691c9a4d6b69af55bb"
    sha256 ventura:        "5c0949e4567b62d7e4dfb5f304ffd2d214dad3bb005c797e7940e55642568fd6"
    sha256 monterey:       "bb48f47b33093d9f1ce94cc3ef7db30e42aaf14707cc29b32e0d41dd124e1157"
    sha256 big_sur:        "9b7f9ae528f37c4782b28baeae1219fe2a054e568fb65483cbb0db8232ba70e1"
    sha256 catalina:       "3292001f4c1720e9c54d0cd4f73df39bbf9136a55843225b2b96bd46b46dfea7"
    sha256 x86_64_linux:   "0b9487a05bc61649e8b7c752cd7b78f69547790366ef08dadccc999356951377"
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

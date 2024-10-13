class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-0.11.0.tar.xz"
  sha256 "846071fb220ac1952f9f15ebbac6c7831ef50d0369b772c07a8a8139a42e07d2"
  license all_of: ["BSD-2-Clause", "LGPL-2.1-or-later", "GPL-2.0-or-later"]
  version_scheme 1

  livecheck do
    url :homepage
    regex(%r{href=(?:["']?|.*?/)libdwarf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "006a219229a3010e9ada7ffbe0aaaff557b7b0ed50e74ad59535545170da23d6"
    sha256 arm64_sonoma:  "5a59b9a8502c5a66cd7106e7af4f64e20ea8e1bfacab1746a45e0db1c8a28fcb"
    sha256 arm64_ventura: "5cfc8adbd5391bb3f2198b09389caabeab41e73633354bf62442d7965095d793"
    sha256 sonoma:        "f4fa659ba9f7cb092b47afe653bf0698e0e83077ea74d4143a7efad5df58bc84"
    sha256 ventura:       "1b9718e58bc84826f8669b5f2ca8d395dec7936cfcac096cc28ac4ae7acb7e26"
    sha256 x86_64_linux:  "feb60defc574c40271d8b4afae3963aafb239112b0004ece1f1bd1a733c95cbb"
  end

  head do
    url "https://github.com/davea42/libdwarf-code.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  uses_from_macos "zlib"

  def install
    system "sh", "autogen.sh" if build.head?
    system "./configure", "--enable-shared", *std_configure_args
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

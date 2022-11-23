class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-0.5.0.tar.xz"
  sha256 "11fa822c60317fa00e1a01a2ac9e8388f6693e8662ab72d352c5f50c7e0112a9"
  license all_of: ["BSD-2-Clause", "LGPL-2.1-or-later", "GPL-2.0-or-later"]
  version_scheme 1

  livecheck do
    url :homepage
    regex(%r{href=(?:["']?|.*?/)libdwarf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "52ec9ac26626f7f65ac66be13b1e7893d02ed8d51aa33f4823b4187eb3332d72"
    sha256 arm64_monterey: "33fe28204eaf01bde656bb1bd8544d6b4c51bdfbeb937b38ff2f2c7ea80c93ee"
    sha256 arm64_big_sur:  "bbf11b56c5b4158101ebd5a670be6a7d81d2ff845059489f29c8b4a8540c4400"
    sha256 ventura:        "01429cc2ab5ddae5e19663851568456c1c7b2a400f91d53e23a0c2ada58e5920"
    sha256 monterey:       "06cd351dae807b6e7e9a6c23bb96a0c03547d01f95dec4e9a598bf05daa04682"
    sha256 big_sur:        "058dec995fd06b9c8511e3cf2eb852ce2443379464058a9c21627ea0b125fc35"
    sha256 catalina:       "de1a049b9cefc01a7f9b25cda493de7d1312088933f871938252e9fd24b545c9"
    sha256 x86_64_linux:   "90bcc4b77d835f80b6b8bec9fbafca434c07c4135242cac29ea86edfbaceffed"
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

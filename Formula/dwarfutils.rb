class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-0.6.0.tar.xz"
  sha256 "8d6f2e67ac6fae59c7019bf41b58fa620187a136cd5977e117f15b820ffc7e75"
  license all_of: ["BSD-2-Clause", "LGPL-2.1-or-later", "GPL-2.0-or-later"]
  version_scheme 1

  livecheck do
    url :homepage
    regex(%r{href=(?:["']?|.*?/)libdwarf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "d559e3a464b50bec8e31b3f4459c3f481108c1476cfb04015e2cb1f2270cca7f"
    sha256 arm64_monterey: "442d4318258f2388763b9a244316d76c2762c53a008e6a7692b6425f509aeec6"
    sha256 arm64_big_sur:  "15a9dc9bb2e9926d0c379268af31d77eed9b10f23c70269afb771ad8133e2d27"
    sha256 ventura:        "a358259d75d04b5eb3f27838094aac4517aee7b51ac7d5cd583a6ef0f943b45c"
    sha256 monterey:       "a50e7c8026586f7677600c87e0de1f81d8d250740fbcbd479e9a0e75a6ad25c1"
    sha256 big_sur:        "9616bc58e2a3fb15607cc8a732cb46ea52f6d7bdcc3bf7644f6a6e0c546e782c"
    sha256 x86_64_linux:   "54545056dd397064fa10c8963e95b59fbbc4ac84a309de264bbbfd153b1311ee"
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

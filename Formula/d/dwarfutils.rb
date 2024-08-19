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
    sha256 arm64_sonoma:   "5de9a578a683c51ad52b7fe8cc27529240e611669be4c0d8bf2f1538ad0cb284"
    sha256 arm64_ventura:  "cb832bbeca30e169a22accb474b0f39d1f878b270365f5b294fafd27683ca296"
    sha256 arm64_monterey: "82e9aeb4f36ef9653b1db4ca33ce12d6279b1f2f27865e37b9443a38d36cfc61"
    sha256 sonoma:         "ba1a7e49387710d019857b1543ebffc2fecdf147d73fa11bf7af1391d1e36c11"
    sha256 ventura:        "953313e57e9e1740b2a4c75d34e0b33bcf53a4214ec4e6732bfe15562027b68b"
    sha256 monterey:       "2e7adf305f4f8db91c13853b31098abeb25f442c8172715475d9b28f6bac85ba"
    sha256 x86_64_linux:   "cc4fade52e1657d55320c7ce223fb2b6d07cbbf86a8843f480210331b24813b6"
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

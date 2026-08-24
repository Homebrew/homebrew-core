class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-2.3.2.tar.xz"
  sha256 "7992e7b9019ebfabdda5773e86243517c48cf89fafed3209e853692bc9573efd"
  license all_of: ["BSD-2-Clause", "LGPL-2.1-or-later", "GPL-2.0-or-later"]
  version_scheme 1
  compatibility_version 1

  livecheck do
    url :homepage
    regex(%r{href=(?:["']?|.*?/)libdwarf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "643aa33e3d75290e16d5331e0c9f410600e04bae54d256425dd18df584f6c190"
    sha256 arm64_sequoia: "acdec047b3dc147910ae5077b5df5b78bf138e4d6bc4e15b5a267d5bff39822f"
    sha256 arm64_sonoma:  "4b9ef180a6ff347e60adb8e76485f9c7b44dbfd3882ccb7737d7373798a29c35"
    sha256 sonoma:        "502e6f5f3904e60e0e936c09231ccd6dd62559f479c84ef6166718e96dd7e539"
    sha256 arm64_linux:   "54131c858e607b095ce19673c4053f38a64e3f99c4fce942d9478aebf197801f"
    sha256 x86_64_linux:  "566bde5460f570bcee6f61fc20b3191ed8608353e89bda0f6ca1dd64b565ea97"
  end

  head do
    url "https://github.com/davea42/libdwarf-code.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

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

class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-0.9.0.tar.xz"
  sha256 "d3cad80a337276a7581bb90ebcddbd743484a99a959157c066dd30f7535db59b"
  license all_of: ["BSD-2-Clause", "LGPL-2.1-or-later", "GPL-2.0-or-later"]
  version_scheme 1

  livecheck do
    url :homepage
    regex(%r{href=(?:["']?|.*?/)libdwarf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "10372cff3bdf11c9349355050e6006cd5bf33e1257070561f8f1dc8198f3c37a"
    sha256 arm64_ventura:  "e64a73405bdbc6642d740c74347413092c520cc9150e7c84ebffd0f518624c55"
    sha256 arm64_monterey: "50423838539f2d7fc8284307a88d0c626fd36e8917a08928f4ab929bc9dc12a2"
    sha256 sonoma:         "5d2d5135249e39545c53e1438eef947d3efe813872867fde72406144d0bb0f6f"
    sha256 ventura:        "43c0fedc66aacb1cadf795d31e34097c0887640f135f9576aa5bcf4f4aa7bcc6"
    sha256 monterey:       "ad99d32892ff13431f2c01dc8816aefffdc9a1d3df15d0e763438c957669aa55"
    sha256 x86_64_linux:   "001b01971a0e92f60e2e5c39cec3aff2e6c21bc0d1f02636287706c315df8fa8"
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

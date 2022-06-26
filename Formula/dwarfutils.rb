class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-0.4.1.tar.xz"
  sha256 "34277b969d30be3cc4c6fbce6926dd3e6f9ea9a27b01951c6753b479aadfd5ef"
  license all_of: ["BSD-2-Clause", "LGPL-2.1-or-later", "GPL-2.0-or-later"]
  version_scheme 1

  livecheck do
    url :homepage
    regex(%r{href=(?:["']?|.*?/)libdwarf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "001bcb6d3d3e84fc305a3f80bde7d82538578aaffd07c14100f1bc3e5771865e"
    sha256 arm64_big_sur:  "a70b0a46e9e130553760e78a71a125c1cd535bfcc17e32841bfac1f80288bff6"
    sha256 monterey:       "955d6aa57869cff77956222b2556a00a6368dd160ca1c01655f0a4ccee2eb584"
    sha256 big_sur:        "8cf0011b85ec960429bc3bb60fcd7eac9829f23f429d202a19a8f613b0844f4b"
    sha256 catalina:       "eb7da561bb0026ea1e74d2851ed76d6cc772166309273b087087db7a60e2a152"
    sha256 x86_64_linux:   "69ac85e10a2069b7f50cf14d280fc7d2c1437372107b21e6df64599a8cd2597a"
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

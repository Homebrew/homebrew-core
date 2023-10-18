class Dwarfutils < Formula
  desc "Dump and produce DWARF debug information in ELF objects"
  homepage "https://www.prevanders.net/dwarf.html"
  url "https://www.prevanders.net/libdwarf-0.8.0.tar.xz"
  sha256 "771814a66b5aadacd8381b22d8a03b9e197bd35c202d27e19fb990e9b6d27b17"
  license all_of: ["BSD-2-Clause", "LGPL-2.1-or-later", "GPL-2.0-or-later"]
  version_scheme 1

  livecheck do
    url :homepage
    regex(%r{href=(?:["']?|.*?/)libdwarf[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "121bcbdda0126ff38186c3ab490416b6066250175421afee0e7d37ab2c352a9b"
    sha256 arm64_ventura:  "c16d31a5057999735bad0fe90d36c6f42d1c473fd9b66ef49f6d08e804d55887"
    sha256 arm64_monterey: "77e820749843db37302e66cc01585cf520884ada4563bf2de678b96f6a53cea5"
    sha256 arm64_big_sur:  "1059900fed3ececa484812fd069fb6a93da59ab3cb4405693b6933bcd81e5d40"
    sha256 sonoma:         "31202697e568e029402f5446bed73ee059a85fb18a98023f7d3a2bb5ef9645f3"
    sha256 ventura:        "e0739ebdafb60bb0ade434c660348e9fdc0e61288ec7899fb781b0ded7258230"
    sha256 monterey:       "a5f8d16f48e507da6a7a1dbc63ab6bed8586056f33bd71463d10714a0caa0008"
    sha256 big_sur:        "3f95dd583de22ea6f88d68f7f759cd81aad5bf8a942d0e108eaf8f2472f2969c"
    sha256 x86_64_linux:   "c586d665fc496ee9c7a9376ccc7a8d481879010a31e28f6f5f7af0585de85f57"
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

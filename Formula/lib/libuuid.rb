class Libuuid < Formula
  desc "Universally unique id library"
  homepage "https://en.wikipedia.org/wiki/Util-linux"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.41/util-linux-2.41.3.tar.xz"
  sha256 "3330d873f0fceb5560b89a7dc14e4f3288bbd880e96903ed9b50ec2b5799e58b"
  license all_of: [
    "BSD-3-Clause",
    :public_domain, # lib/
  ]

  livecheck do
    formula "util-linux"
  end

  keg_only :shadowed_by_macos, "macOS provides libuuid in libSystem and the uuid.h header"

  on_macos do
    depends_on "gettext"
  end

  # conflicts_with "ossp-uuid", because: "both install `libuuid.a`"

  link_overwrite "include/uuid/uuid.h", "lib/libuuid.*", "lib/pkgconfig/uuid.pc", "share/man/man3/uuid*.3"

  def install
    system "./configure", "--disable-all-programs",
                          "--disable-silent-rules",
                          "--enable-libuuid",
                          *std_configure_args
    system "make", "install"

    # Remove files that conflict with `util-linux`
    rm_r(share/"locale")
    rm(man5/"terminal-colors.d.5")

    # Install the correct main license and avoid duplicating `util-linux` metafiles
    prefix.install "libuuid/COPYING", "Documentation/licenses/COPYING.BSD-3-Clause"
    rm(buildpath.children.select(&:file?))
  end

  test do
    # https://github.com/util-linux/util-linux/blob/master/libuuid/src/test_uuid.c
    (testpath/"test.c").write <<~'C'
      #include <stdio.h>
      #include <uuid.h>

      static int test_uuid(const char * uuid, int isValid) {
        static const char * validStr[2] = {"invalid", "valid"};
        uuid_t uuidBits;
        int parsedOk;

        parsedOk = uuid_parse(uuid, uuidBits) == 0;

        printf("%s is %s", uuid, validStr[isValid]);
        if (parsedOk != isValid) {
          printf(" but uuid_parse says %s\n", validStr[parsedOk]);
          return 1;
        }
        printf(", OK\n");
        return 0;
      }

      int main(void) {
        return test_uuid("84949cc5-4701-4a84-895b-354c584a981b", 1);
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-I#{include}/uuid", "-L#{lib}", "-luuid"
    assert_match "OK", shell_output("./test")
  end
end

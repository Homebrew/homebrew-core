class Libblkid < Formula
  desc "Block device identification library"
  homepage "https://en.wikipedia.org/wiki/Util-linux"
  url "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.41/util-linux-2.41.3.tar.xz"
  sha256 "3330d873f0fceb5560b89a7dc14e4f3288bbd880e96903ed9b50ec2b5799e58b"
  license all_of: [
    "LGPL-2.1-or-later",
    "BSD-2-Clause", # lib/xxhash.c
    "BSD-3-Clause", # lib/randutils.c
    "MIT",          # lib/crc64.c
    :public_domain, # lib/
  ]

  livecheck do
    formula "util-linux"
  end

  on_macos do
    depends_on "gettext"
  end

  link_overwrite "include/blkid/blkid.h", "lib/libblkid.*", "lib/pkgconfig/blkid.pc", "share/man/man3/libblkid.3"

  def install
    system "./configure", "--disable-all-programs",
                          "--disable-silent-rules",
                          "--enable-libblkid",
                          *std_configure_args
    system "make", "install"

    # Remove files that conflict with `util-linux`
    rm_r(share/"locale")
    rm(man5/"terminal-colors.d.5")

    # Install the correct main license and avoid duplicating `util-linux` metafiles
    prefix.install "libblkid/COPYING", "Documentation/licenses/COPYING.LGPL-2.1-or-later"
    rm(buildpath.children.select(&:file?))
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <blkid.h>

      int main(void) {
        blkid_probe pr = blkid_new_probe_from_filename("./data");
        if (!pr) {
          printf("failed to create a new libblkid probe");
          return 1;
        }
        printf("size: %jd", (intmax_t)blkid_probe_get_size(pr));
        return 0;
      }
    C

    (testpath/"data").write "homebrew"
    system ENV.cc, "test.c", "-o", "test", "-I#{include}/blkid", "-L#{lib}", "-lblkid"
    assert_equal "size: 8", shell_output("./test")
  end
end

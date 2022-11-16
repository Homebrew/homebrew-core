class E2fsprogs < Formula
  desc "Utilities for the ext2, ext3, and ext4 file systems"
  homepage "https://e2fsprogs.sourceforge.io/"
  license all_of: [
    "GPL-2.0-or-later",
    "LGPL-2.0-or-later", # lib/ex2fs
    "LGPL-2.0-only",     # lib/e2p
    "BSD-3-Clause",      # lib/uuid
    "MIT",               # lib/et, lib/ss
  ]
  head "https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git", branch: "master"

  stable do
    url "https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.46.5/e2fsprogs-1.46.5.tar.gz"
    sha256 "b7430d1e6b7b5817ce8e36d7c8c7c3249b3051d0808a96ffd6e5c398e4e2fbb9"

    # Remove `-flat_namespace` flag and fix M1 shared library build.
    # Sent via email to theodore.tso@gmail.com
    patch :DATA
  end

  livecheck do
    url :stable
    regex(%r{url=.*?/e2fsprogs[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 2
    sha256 arm64_ventura:  "ea5c3806ca772a4f15759d1372a2b37b5390d5a4be6cf6a7b0fb6107a8d7d029"
    sha256 arm64_monterey: "474e58e01910204a775eb12ab6322025c5468088f857d71dbde0a37462412255"
    sha256 arm64_big_sur:  "5296cb03cc130751689a14bbdedb21018f07e3cd3ada7b88f811d748a79dc38c"
    sha256 ventura:        "a232d3349b0b702b5d109cd4778ee305563c713b5b312dd5bc64e68ad0bbf504"
    sha256 monterey:       "2d0d0cf4044a8d608ccadd4c57ea6e9e4f0a0a380fc03386993053cb715e9bfa"
    sha256 big_sur:        "a2e07e058b28329521afa738526942e344d107630f8312eacd43b57ce752bde8"
    sha256 catalina:       "956dbc649227546cc36afcc88a89651bd99b89116f8d8c2e00cfcf375f9e98c7"
    sha256 x86_64_linux:   "964d0ca9f5517c4137dbac355540b97b21b35229e918072de437d4528dfa5a69"
  end

  keg_only "this installs several executables which shadow macOS system commands"

  depends_on "pkg-config" => :build

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "util-linux"
  end

  def install
    # Enforce MKDIR_P to work around a configure bug
    # see https://github.com/Homebrew/homebrew-core/pull/35339
    # and https://sourceforge.net/p/e2fsprogs/discussion/7053/thread/edec6de279/
    args = [
      "--prefix=#{prefix}",
      "--sysconfdir=#{etc}",
      "--disable-e2initrd-helper",
      "MKDIR_P=mkdir -p",
    ]
    args += if OS.linux?
      %w[
        --enable-elf-shlibs
        --disable-fsck
        --disable-uuidd
        --disable-libuuid
        --disable-libblkid
        --without-crond-dir
      ]
    else
      ["--enable-bsd-shlibs"]
    end

    system "./configure", *args

    system "make"

    # Fix: lib/libcom_err.1.1.dylib: No such file or directory
    ENV.deparallelize

    system "make", "install"
    system "make", "install-libs"
  end

  test do
    assert_equal 36, shell_output("#{bin}/uuidgen").strip.length if OS.mac?
    system bin/"lsattr", "-al"
  end
end

__END__
diff --git a/lib/Makefile.darwin-lib b/lib/Makefile.darwin-lib
index 95cdd4b..95e8ee0 100644
--- a/lib/Makefile.darwin-lib
+++ b/lib/Makefile.darwin-lib
@@ -24,7 +24,8 @@ image:		$(BSD_LIB)
 $(BSD_LIB): $(OBJS)
 	$(E) "	GEN_BSD_SOLIB $(BSD_LIB)"
 	$(Q) (cd pic; $(CC) -dynamiclib -compatibility_version 1.0 -current_version $(BSDLIB_VERSION) \
-		-flat_namespace -undefined warning -o $(BSD_LIB) $(OBJS))
+		-install_name $(BSDLIB_INSTALL_DIR)/$(BSD_LIB) \
+		-undefined dynamic_lookup -o $(BSD_LIB) $(OBJS))
 	$(Q) $(MV) pic/$(BSD_LIB) .
 	$(Q) $(RM) -f ../$(BSD_LIB)
 	$(Q) (cd ..; $(LN) $(LINK_BUILD_FLAGS) \

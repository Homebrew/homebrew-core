class E2fsprogs < Formula
  desc "Utilities for the ext2, ext3, and ext4 file systems"
  homepage "https://e2fsprogs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/v1.46.5/e2fsprogs-1.46.5.tar.gz"
  sha256 "b7430d1e6b7b5817ce8e36d7c8c7c3249b3051d0808a96ffd6e5c398e4e2fbb9"
  license all_of: [
    "GPL-2.0-or-later",
    "LGPL-2.0-or-later", # lib/ex2fs
    "LGPL-2.0-only",     # lib/e2p
    "BSD-3-Clause",      # lib/uuid
    "MIT",               # lib/et, lib/ss
  ]
  head "https://git.kernel.org/pub/scm/fs/ext2/e2fsprogs.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/e2fsprogs[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "0704bc2eb7f67d1ae9359ce0a88df93c5fea7983bc244aeb056b76ff862bbd90"
    sha256 arm64_big_sur:  "b089beb986fdbc2f9a699c98ea0d7453b434a819b18e09183c8a2e54368b4652"
    sha256 monterey:       "b5f7734b3d5f8fc599814c035f5a81e2b5c519dfa0269d8c777babc794cc9f80"
    sha256 big_sur:        "93c43050723e83dc54e9acda04b49bb9651d561a8f179b0a2837dc0b4dbc488d"
    sha256 catalina:       "e629177b97c03f0c073ab805dd1d452b210f4b206e63da826793420c64d151eb"
    sha256 mojave:         "d494d4d21d05c76acdeb381b38d2bd343cd4d1b5e536a1d2f99ebceb8fb5d917"
    sha256 x86_64_linux:   "cf06e4cdcc4588246eb66b3fd10d9a8424494578e7821e6e273a030fcea09d28"
  end

  keg_only "this installs several executables which shadow macOS system commands"

  depends_on "pkg-config" => :build
  depends_on "gettext"

  # Remove `-flat_namespace` flag and fix M1 shared library build.
  # Sent via email to theodore.tso@gmail.com
  patch :DATA

  def install
    # Fix "unknown type name 'loff_t'" issue
    inreplace "lib/ext2fs/imager.c", "loff_t", "off_t"
    inreplace "misc/e2fuzz.c", "loff_t", "off_t"

    # Enforce MKDIR_P to work around a configure bug
    # see https://github.com/Homebrew/homebrew-core/pull/35339
    # and https://sourceforge.net/p/e2fsprogs/discussion/7053/thread/edec6de279/
    args = [
      "--prefix=#{prefix}",
      "--disable-e2initrd-helper",
      "MKDIR_P=mkdir -p",
    ]
    args << if OS.linux?
      "--enable-elf-shlibs"
    else
      "--enable-bsd-shlibs"
    end

    system "./configure", *args

    system "make"

    # Fix: lib/libcom_err.1.1.dylib: No such file or directory
    ENV.deparallelize

    system "make", "install"
    system "make", "install-libs"
  end

  test do
    assert_equal 36, shell_output("#{bin}/uuidgen").strip.length
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

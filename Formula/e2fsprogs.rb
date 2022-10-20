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
    rebuild 1
    sha256 arm64_monterey: "8beaf96158b784312741d8cc6347c620fb5edbba4734d0b8f66bdb0fca0eb3f2"
    sha256 arm64_big_sur:  "8555d6ccc90f4fa60d82a5437477353d0bb71cb3118f40f8780e482176ec8554"
    sha256 monterey:       "2b72446f9b3aba610819a0d8bd26a3c3e61f6726806f9d1b02083d72731bf18c"
    sha256 big_sur:        "22f8986cf60259c01fa044bff397fa876ab3be1c8172413b46c0b4164695545c"
    sha256 catalina:       "6e2776279753101a6d35c0e9329a5f7dab51ebafd281558a1c61944159b5cadb"
    sha256 x86_64_linux:   "1d2489a49365b866a54b18ae749181c1c9b61f3b23c2646e1d28fdef1c624649"
  end

  keg_only "this installs several executables which shadow macOS system commands"

  depends_on "pkg-config" => :build
  depends_on "gettext"

  # Remove `-flat_namespace` flag and fix M1 shared library build.
  # Sent via email to theodore.tso@gmail.com
  patch :DATA

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

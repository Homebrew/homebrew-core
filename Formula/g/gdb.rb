class Gdb < Formula
  desc "GNU debugger"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-16.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-16.1.tar.xz"
  sha256 "c2cc5ccca029b7a7c3879ce8a96528fdfd056b4d884f2b0511e8f7bc723355c6"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  bottle do
    sha256 sonoma:       "5ee7e0844dc1e5e74e7936504e954b18b85bcff2856e301ddcbb6f171221f25c"
    sha256 ventura:      "7b6cfecf7cc06a1e5408fb95ca06a3059eb3755662a9907a9c358a9a8d7d1b87"
    sha256 x86_64_linux: "1e88e9c902f2d417c8aa7eb215f888d7e37cf6899b4f2c6521f98384d6824ab0"
  end

  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.12"
  depends_on "xz" # required for lzma support

  uses_from_macos "expat"
  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  on_macos do
    depends_on arch: :x86_64 # gdb is not supported on macOS ARM
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "guile"
  end

  fails_with :clang do
    build 800
    cause <<~EOS
      probe.c:63:28: error: default initialization of an object of const type
      'const any_static_probe_ops' without a user-provided default constructor
    EOS
  end

  # Fix build on Linux
  # Ref: https://sourceware.org/bugzilla/show_bug.cgi?id=32578
  patch :DATA

  def install
    # Fix `error: use of undeclared identifier 'command_style'`
    inreplace "gdb/darwin-nat.c", "#include \"cli/cli-cmds.h\"",
                                  "#include \"cli/cli-cmds.h\"\n#include \"cli/cli-style.h\""

    args = %W[
      --enable-targets=all
      --with-lzma
      --with-python=#{Formula["python@3.12"].opt_bin}/python3.12
      --disable-binutils
    ]

    mkdir "build" do
      system "../configure", *args, *std_configure_args
      system "make"

      # Don't install bfd or opcodes, as they are provided by binutils
      system "make", "install-gdb", "maybe-install-gdbserver"
    end
  end

  def caveats
    on_macos do
      <<~EOS
        gdb requires special privileges to access Mach ports.
        You will need to codesign the binary. For instructions, see:

          https://sourceware.org/gdb/wiki/PermissionsDarwin
      EOS
    end
  end

  test do
    system bin/"gdb", bin/"gdb", "-configuration"
  end
end

__END__
diff --git a/bfd/Makefile.in b/bfd/Makefile.in
index aec3717485a..ee674a36c5b 100644
--- a/bfd/Makefile.in
+++ b/bfd/Makefile.in
@@ -1318,7 +1318,7 @@ REGEN_TEXI = \
 	$(MKDOC) -f $(srcdir)/doc/doc.str < $< > $@.tmp; \
 	texi=$@; \
 	texi=$${texi%.stamp}.texi; \
-	test -e $$texi || test ! -f $(srcdir)/$$texi || $(LN_S) $(srcdir)/$$texi $$texi; \
+	test -e $$texi || test ! -f $(srcdir)/$$texi || $(LN_S) $(abs_srcdir)/$$texi $$texi; \
 	$(SHELL) $(srcdir)/../move-if-change $@.tmp $$texi; \
 	touch $@; \
 	)
diff --git a/bfd/doc/local.mk b/bfd/doc/local.mk
index 97d658b5a48..9b75402387c 100644
--- a/bfd/doc/local.mk
+++ b/bfd/doc/local.mk
@@ -101,7 +101,7 @@ REGEN_TEXI = \
 	$(MKDOC) -f $(srcdir)/%D%/doc.str < $< > $@.tmp; \
 	texi=$@; \
 	texi=$${texi%.stamp}.texi; \
-	test -e $$texi || test ! -f $(srcdir)/$$texi || $(LN_S) $(srcdir)/$$texi $$texi; \
+	test -e $$texi || test ! -f $(srcdir)/$$texi || $(LN_S) $(abs_srcdir)/$$texi $$texi; \
 	$(SHELL) $(srcdir)/../move-if-change $@.tmp $$texi; \
 	touch $@; \
 	)

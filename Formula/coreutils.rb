class Coreutils < Formula
  desc "GNU File, Shell, and Text utilities"
  homepage "https://www.gnu.org/software/coreutils"
  url "https://ftp.gnu.org/gnu/coreutils/coreutils-9.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/coreutils/coreutils-9.0.tar.xz"
  sha256 "ce30acdf4a41bc5bb30dd955e9eaa75fa216b4e3deb08889ed32433c7b3b97ce"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_monterey: "e7d849e225505512eaa003bfa599bed9b17d935467e3d33f13ff44017118ab41"
    sha256 arm64_big_sur:  "cb659580e450fa90dc63b9bf3b0cd85aea2b2636e9d6844dc7c098179ec9128d"
    sha256 monterey:       "b01dbccfa5988b39fb63031999d14dd0f3777df2eafe4e18e86ec000f36c6a23"
    sha256 big_sur:        "a5f2ae877c7b2d542e8156e5739a166652482f270dce0bc79cf5f85c4629d358"
    sha256 catalina:       "d7942e4d7f275b9bc17a7d6e7b1d916ac1e7359b58fdeadadd5e6de9040d1080"
    sha256 x86_64_linux:   "93f2bb75dd42786a4c72c97f839a918cfe3f32cd9040dbdc174606473803335b"
  end

  head do
    url "https://git.savannah.gnu.org/git/coreutils.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "gettext" => :build
    depends_on "texinfo" => :build
    depends_on "wget" => :build
    depends_on "xz" => :build
  end

  # autoconf, automake are required for patch :DATA. remove when dropping patch
  # https://github.com/Homebrew/homebrew-core/pull/94432
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gmp"
  uses_from_macos "gperf" => :build

  on_linux do
    depends_on "attr"
  end

  conflicts_with "aardvark_shell_utils", because: "both install `realpath` binaries"
  conflicts_with "b2sum", because: "both install `b2sum` binaries"
  conflicts_with "ganglia", because: "both install `gstat` binaries"
  conflicts_with "gdu", because: "both install `gdu` binaries"
  conflicts_with "gegl", because: "both install `gcut` binaries"
  conflicts_with "idutils", because: "both install `gid` and `gid.1`"
  conflicts_with "md5sha1sum", because: "both install `md5sum` and `sha1sum` binaries"
  conflicts_with "truncate", because: "both install `truncate` binaries"
  conflicts_with "uutils-coreutils", because: "coreutils and uutils-coreutils install the same binaries"

  # https://github.com/Homebrew/homebrew-core/pull/36494
  def breaks_macos_users
    %w[dir dircolors vdir]
  end

  # patch to fix cp 0x00 bytes bug, probably can be removed after 9.0 release
  # https://github.com/Homebrew/homebrew-core/pull/94432
  patch :DATA

  def install
    system "./bootstrap" if build.head?

    args = %W[
      --prefix=#{prefix}
      --program-prefix=g
      --with-gmp
      --without-selinux
    ]

    # aclocal is required for patch :DATA. remove when dropping patch
    # https://github.com/Homebrew/homebrew-core/pull/94432
    system "aclocal", "-Im4"
    system "./configure", *args
    system "make", "install"

    no_conflict = if OS.mac?
      []
    else
      %w[
        b2sum base32 basenc chcon dir dircolors factor hostid md5sum nproc numfmt pinky ptx realpath runcon
        sha1sum sha224sum sha256sum sha384sum sha512sum shred shuf stdbuf tac timeout truncate vdir
      ]
    end

    # Symlink all commands into libexec/gnubin without the 'g' prefix
    coreutils_filenames(bin).each do |cmd|
      (libexec/"gnubin").install_symlink bin/"g#{cmd}" => cmd

      # Find non-conflicting commands on macOS
      which_cmd = which(cmd)
      no_conflict << cmd if OS.mac? && (which_cmd.nil? || !which_cmd.to_s.start_with?(%r{(/usr)?/s?bin}))
    end
    # Symlink all man(1) pages into libexec/gnuman without the 'g' prefix
    coreutils_filenames(man1).each do |cmd|
      (libexec/"gnuman"/"man1").install_symlink man1/"g#{cmd}" => cmd
    end
    libexec.install_symlink "gnuman" => "man"

    no_conflict -= breaks_macos_users if OS.mac?
    # Symlink non-conflicting binaries
    no_conflict.each do |cmd|
      bin.install_symlink "g#{cmd}" => cmd
      man1.install_symlink "g#{cmd}.1" => "#{cmd}.1"
    end
  end

  def caveats
    msg = "Commands also provided by macOS and the commands #{breaks_macos_users.join(", ")}"
    on_linux do
      msg = "All commands"
    end
    <<~EOS
      #{msg} have been installed with the prefix "g".
      If you need to use these commands with their normal names, you can add a "gnubin" directory to your PATH with:
        PATH="#{opt_libexec}/gnubin:$PATH"
    EOS
  end

  def coreutils_filenames(dir)
    filenames = []
    dir.find do |path|
      next if path.directory? || path.basename.to_s == ".DS_Store"

      filenames << path.basename.to_s.sub(/^g/, "")
    end
    filenames.sort
  end

  test do
    (testpath/"test").write("test")
    (testpath/"test.sha1").write("a94a8fe5ccb19ba61c4c0873d391e987982fbbd3 test")
    system bin/"gsha1sum", "-c", "test.sha1"
    system bin/"gln", "-f", "test", "test.sha1"
  end
end

__END__
coreutils: fix cp filling destination files with 0x00 bytes:
- https://github.com/Homebrew/homebrew-core/pull/94432
- https://github.com/Homebrew/homebrew-core/issues/94405

Upstream bug:
- https://debbugs.gnu.org/cgi/bugreport.cgi?bug=51857

This patch cherry picks following commits from gnulib:
- 4db8db34112b86ddf8bac48f16b5acff732b5fa9
- 1a268176fbb184e393c98575e61fe692264c7d91

These patches will be very likely included next coreutils version followed by 9.0

--
Elan Ruusamäe <glen@pld-linux.org>

From 4db8db34112b86ddf8bac48f16b5acff732b5fa9 Mon Sep 17 00:00:00 2001
From: Paul Eggert <eggert@cs.ucla.edu>
Date: Mon, 15 Nov 2021 15:08:25 -0800
Subject: [PATCH] lseek: port around macOS SEEK_DATA glitch

Problem reported by Sudhip Nashi (Bug#51857).
* doc/posix-functions/lseek.texi (lseek): Mention macOS SEEK_DATA
issue.
* lib/lseek.c (rpl_lseek): Work around macOS portability glitch.
* m4/lseek.m4 (gl_FUNC_LSEEK): Replace lseek on Darwin.
* modules/lseek (Depends-on): Depend on msvc-nothrow
and fstat only if needed.
---
 ChangeLog                      | 11 +++++++++++
 doc/posix-functions/lseek.texi |  4 ++++
 lib/lseek.c                    | 16 ++++++++++++++++
 m4/lseek.m4                    | 10 ++++++++--
 modules/lseek                  |  4 ++--
 5 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/lib/lseek.c b/lib/lseek.c
index 0042546a8..7dcd6c9da 100644
--- a/lib/lseek.c
+++ b/lib/lseek.c
@@ -52,6 +52,22 @@ rpl_lseek (int fd, off_t offset, int whence)
       errno = ESPIPE;
       return -1;
     }
+#elif defined __APPLE__ && defined __MACH__ && defined SEEK_DATA
+  if (whence == SEEK_DATA)
+    {
+      /* If OFFSET points to data, macOS lseek+SEEK_DATA returns the
+         start S of the first data region that begins *after* OFFSET,
+         where the region from OFFSET to S consists of possibly-empty
+         data followed by a possibly-empty hole.  To work around this
+         portability glitch, check whether OFFSET is within data by
+         using lseek+SEEK_HOLE, and if so return to OFFSET by using
+         lseek+SEEK_SET.  */
+      off_t next_hole = lseek (fd, offset, SEEK_HOLE);
+      if (next_hole < 0)
+        return next_hole;
+      if (next_hole != offset)
+        whence = SEEK_SET;
+    }
 #else
   /* BeOS lseek mistakenly succeeds on pipes...  */
   struct stat statbuf;
diff --git a/m4/lseek.m4 b/m4/lseek.m4
index 0af63780a..faab09b73 100644
--- a/m4/lseek.m4
+++ b/m4/lseek.m4
@@ -1,4 +1,4 @@
-# lseek.m4 serial 11
+# lseek.m4 serial 12
 dnl Copyright (C) 2007, 2009-2021 Free Software Foundation, Inc.
 dnl This file is free software; the Free Software Foundation
 dnl gives unlimited permission to copy and/or distribute it,
@@ -59,7 +59,7 @@ AC_DEFUN([gl_FUNC_LSEEK],
          ;;
      esac
     ])
-  if test $gl_cv_func_lseek_pipe = no; then
+  if test "$gl_cv_func_lseek_pipe" = no; then
     REPLACE_LSEEK=1
     AC_DEFINE([LSEEK_PIPE_BROKEN], [1],
       [Define to 1 if lseek does not detect pipes.])
@@ -69,4 +69,10 @@ AC_DEFUN([gl_FUNC_LSEEK],
   if test $WINDOWS_64_BIT_OFF_T = 1; then
     REPLACE_LSEEK=1
   fi
+
+  dnl macOS SEEK_DATA is incompatible with other platforms.
+  case $host_os in
+    darwin*)
+      REPLACE_LSEEK=1;;
+  esac
 ])
From 1a268176fbb184e393c98575e61fe692264c7d91 Mon Sep 17 00:00:00 2001
From: Paul Eggert <eggert@cs.ucla.edu>
Date: Mon, 15 Nov 2021 22:17:44 -0800
Subject: [PATCH] lseek: port around macOS SEEK_HOLE glitch

Problem reported by Sudhip Nashi (Bug#51857#47).
* lib/lseek.c (rpl_lseek): Work around macOS lseek+SEEK_HOLE
returning -1 with ENXIO if there are no holes before EOF,
contrary to the macOS documentation.
---
 ChangeLog   | 6 ++++++
 lib/lseek.c | 6 ++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/lib/lseek.c b/lib/lseek.c
index 7dcd6c9da..e9a96ad20 100644
--- a/lib/lseek.c
+++ b/lib/lseek.c
@@ -61,10 +61,12 @@ rpl_lseek (int fd, off_t offset, int whence)
          data followed by a possibly-empty hole.  To work around this
          portability glitch, check whether OFFSET is within data by
          using lseek+SEEK_HOLE, and if so return to OFFSET by using
-         lseek+SEEK_SET.  */
+         lseek+SEEK_SET.  Also, contrary to the macOS documentation,
+         lseek+SEEK_HOLE can fail with ENXIO if there are no holes on
+         or after OFFSET.  What a mess!  */
       off_t next_hole = lseek (fd, offset, SEEK_HOLE);
       if (next_hole < 0)
-        return next_hole;
+        return errno == ENXIO ? offset : next_hole;
       if (next_hole != offset)
         whence = SEEK_SET;
     }
-- 
2.35.1


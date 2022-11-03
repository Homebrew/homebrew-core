class Makepkg < Formula
  desc "Compile and build packages suitable for installation with pacman"
  homepage "https://wiki.archlinux.org/index.php/makepkg"
  url "https://gitlab.archlinux.org/pacman/pacman.git",
      tag:      "v6.0.1",
      revision: "0a6fecd07271a54d9009ea7204c0e6288a44212b"
  license "GPL-2.0"
  head "https://gitlab.archlinux.org/pacman/pacman.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "5ca7e70318a15047c04e49bfea4f0ef3ec0d7da76979d9c022d8ebffdc363a8c"
    sha256 arm64_big_sur:  "4bfbabe25969b1139c9ec3dbe49ca4f8558c130b75562a9e519de8867aaa5056"
    sha256 monterey:       "42c8e986de6528e53105bf589ce88d04ea55ed1eba44004b8b2c391d2291c1d5"
    sha256 big_sur:        "0ccfa9ec3e4b23998f7e64f0c0ea4f3594a29b25de2e79cf143a79f505aaedd3"
    sha256 catalina:       "4cf043ba4fed67c8af65fff9c0e7b9f711db3f759ba428cb415e1a750fbaa32c"
    sha256 x86_64_linux:   "c36e4fed92a9b2fffcb2280afa507be8c3b3b750e754c2eb0a10d4a9f8bd10e8"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "bash"
  depends_on "fakeroot"
  depends_on "libarchive"
  depends_on "openssl@1.1"

  uses_from_macos "m4" => :build
  uses_from_macos "python" => :build
  uses_from_macos "libxslt"

  on_macos do
    depends_on "coreutils" => :test # for md5sum
  end

  on_linux do
    depends_on "gettext"
  end

  # Submitted upstream: https://www.mail-archive.com/pacman-dev@lists.archlinux.org/msg00896.html
  # Remove when these fixes have been merged.
  patch :DATA

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    args = %W[
      -Dmakepkg-template-dir=#{share}/makepkg-template
      -Dsysconfdir=#{etc}
      -Dlocalstatedir=#{var}
      -Ddoc=disabled
    ]

    args << "-Di18n=false" if OS.mac?

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"PKGBUILD").write <<~EOS
      pkgname=androidnetworktester
      pkgname=test
      source=(https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/androidnetworktester/10kb.txt)
      pkgrel=0
      pkgver=0
      md5sums=('e232a2683c04881e292d5f7617d6dc6f')
    EOS
    assert_match "md5sums=('e232a2683c0", pipe_output("#{bin}/makepkg -dg 2>&1")
  end
end

__END__
diff --git a/meson.build b/meson.build
index 76b9d2aa..e904056a 100644
--- a/meson.build
+++ b/meson.build
@@ -175,7 +175,8 @@ foreach type : [
   endif
 endforeach
 
-if conf.has('HAVE_STRUCT_STATVFS_F_FLAG')
+os = host_machine.system()
+if conf.has('HAVE_STRUCT_STATVFS_F_FLAG') and not os.startswith('darwin')
   conf.set('FSSTATSTYPE', 'struct statvfs')
 elif conf.has('HAVE_STRUCT_STATFS_F_FLAGS')
   conf.set('FSSTATSTYPE', 'struct statfs')
@@ -235,7 +236,6 @@ if file_seccomp.enabled() or ( file_seccomp.auto() and filever.version_compare('
   filecmd = 'file -S'
 endif
 
-os = host_machine.system()
 if os.startswith('darwin')
   inodecmd = '/usr/bin/stat -f \'%i %N\''
   strip_binaries = ''
diff --git a/lib/libalpm/util.c b/lib/libalpm/util.c
index 299d287e..fa8ccb79 100644
--- a/lib/libalpm/util.c
+++ b/lib/libalpm/util.c
@@ -93,6 +93,10 @@ char *strsep(char **str, const char *delims)
 }
 #endif
 
+#ifndef MSG_NOSIGNAL
+#define MSG_NOSIGNAL 0
+#endif
+
 int _alpm_makepath(const char *path)
 {
 	return _alpm_makepath_mode(path, 0755);

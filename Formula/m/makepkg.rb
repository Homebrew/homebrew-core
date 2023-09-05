class Makepkg < Formula
  desc "Compile and build packages suitable for installation with pacman"
  homepage "https://wiki.archlinux.org/index.php/makepkg"
  url "https://gitlab.archlinux.org/pacman/pacman.git",
      tag:      "v6.0.2",
      revision: "c2d4568d35173f92c17b6b93222bc101a63c9928"
  license "GPL-2.0-or-later"
  revision 1
  head "https://gitlab.archlinux.org/pacman/pacman.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "011744cbb816a05814602965407c8ac925a9be34a6171fe42e31c6666a8493b2"
    sha256 arm64_monterey: "4a4742a7f5f753516099e046b0b1c3b879f89831c354e944dc585ba1a9a9c349"
    sha256 arm64_big_sur:  "6552ccbd2e4f17df87f76c47279cf0559c2337ec468a082c29cc0b4234d6db87"
    sha256 ventura:        "5e85ee58f8aa02dee02ea59a2f4541bfb09e58eec62738e530a523645b1a9361"
    sha256 monterey:       "32e5c652bea73bee42c11336be0470b85158283379e98f36f67495ad471baa73"
    sha256 big_sur:        "08dd5419b09e11c7229e6ae578b44aec8697e4c9d421e35836d8bda115f6a1e5"
    sha256 x86_64_linux:   "3997babcd7a7b6937c55722f821713d77a7b7864f1f52756b2711e756190deca"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "bash"
  depends_on "fakeroot"
  depends_on "libarchive"
  depends_on "openssl@3"

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

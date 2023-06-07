class Makepkg < Formula
  desc "Compile and build packages suitable for installation with pacman"
  homepage "https://wiki.archlinux.org/index.php/makepkg"
  url "https://gitlab.archlinux.org/pacman/pacman.git",
      tag:      "v6.0.2",
      revision: "c2d4568d35173f92c17b6b93222bc101a63c9928"
  license "GPL-2.0-or-later"
  head "https://gitlab.archlinux.org/pacman/pacman.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "5e5d9de1d83fb49b3fd36165683c954895dc035719c737841b4edf5d79ad14f9"
    sha256 arm64_monterey: "f0c7743fdf8bfe0deb368c352cb5a219f42ac0febcdf7c3c30ce0a788a518798"
    sha256 arm64_big_sur:  "e9f0e5e5b90d6fece072a301079ba6c742e546449df60cba7e02fc539e63d74f"
    sha256 ventura:        "235a0ff1a77016a1fd2c4bc9bedf97b0a8ef7e56df90d3afec7b795c9f56f59a"
    sha256 monterey:       "5415bbb41478428b88286fd67233c8186d99d037a17806d5bba06cb30092cead"
    sha256 big_sur:        "76a202cee610d899d609489c1350fd1d29b70979f3acb11744528fe7bea6e078"
    sha256 catalina:       "34b6a994323eac1b2daa873577c45df38af97867dee31ae7195bd4fb934d6b2a"
    sha256 x86_64_linux:   "2ecea508e50743b2aedb42a64d026a0481ff16374a55ee18d619ee3761cfc407"
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

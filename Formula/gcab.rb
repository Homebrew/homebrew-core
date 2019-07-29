class Gcab < Formula
  desc "Windows installer (.MSI) tool"
  homepage "https://wiki.gnome.org/msitools"
  url "https://download.gnome.org/sources/gcab/1.2/gcab-1.2.tar.xz"
  sha256 "5a2d96fe7e69e42d363c31cf2370d7afa3bb69cec984d4128322ea40e62c100d"
  revision 1

  bottle do
    sha256 "b72ded95967c164253ee795435637e99dbe62202c82ad8a5730a5753a0f1a0af" => :mojave
    sha256 "49f8e335616b55f0c3ee19078b7a2fc58e0066fba206adc94be76107f6f843ed" => :high_sierra
    sha256 "257cac0a43760726ec36ea892695236a787b50f29bd41f6db67225200a9478c7" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson-internal" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "vala" => :build
  depends_on "glib"

  # work around ld not understanding --version-script argument
  # upstream bug: https://bugzilla.gnome.org/show_bug.cgi?id=708257
  patch :DATA

  def install
    ENV.refurbish_args

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "-Ddocs=false", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    system "#{bin}/gcab", "--version"
  end
end

__END__
diff --git a/libgcab/meson.build b/libgcab/meson.build
index 6ff8801..3d1a350 100644
--- a/libgcab/meson.build
+++ b/libgcab/meson.build
@@ -27,8 +27,6 @@ install_headers([
   subdir : 'libgcab-1.0/libgcab',
 )

-mapfile = 'libgcab.syms'
-vflag = '-Wl,--version-script,@0@/@1@'.format(meson.current_source_dir(), mapfile)
 libgcab = shared_library(
   'gcab-1.0',
   enums,
@@ -50,8 +48,6 @@ libgcab = shared_library(
     include_directories('.'),
     include_directories('..'),
   ],
-  link_args : vflag,
-  link_depends : mapfile,
   install : true
 )

diff --git a/meson.build b/meson.build
index 1a29b5a..ff45829 100644
--- a/meson.build
+++ b/meson.build
@@ -72,10 +72,7 @@ endforeach
 # enable full RELRO where possible
 # FIXME: until https://github.com/mesonbuild/meson/issues/1140 is fixed
 global_link_args = []
-test_link_args = [
-  '-Wl,-z,relro',
-  '-Wl,-z,now',
-]
+test_link_args = []
 foreach arg: test_link_args
   if cc.has_argument(arg)
     global_link_args += arg


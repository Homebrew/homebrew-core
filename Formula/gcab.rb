class Gcab < Formula
  desc "Windows installer (.MSI) tool"
  homepage "https://wiki.gnome.org/msitools"
  url "https://download.gnome.org/sources/gcab/1.3/gcab-1.3.tar.xz"
  sha256 "10304cc8f6b550cf9f53fb3cebfb529c49394e982ef7e66e3fca9776c60a68e7"

  bottle do
    sha256 "89ab0f14efac9b2daea83b157a2fa46d9ab20c02cb649d8527b021ca1dc3b387" => :catalina
    sha256 "504b51791d61119bfc8a378cce00b2b1c7f9cf85bfc833ee75b74647aabe5e36" => :mojave
    sha256 "b41c08852ef80aa118629092f66c4b3d465649e32756d6ecaf6588a6a88ad0b3" => :high_sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "vala" => :build
  depends_on "glib"

  # patch submitted upstream as https://gitlab.gnome.org/GNOME/gcab/merge_requests/3
  patch do
    url "https://gitlab.gnome.org/GNOME/gcab/commit/94dc0cacbd25ce6e9a33018ad63247602653afb6.diff"
    sha256 "adf25894d7a0a1408982ce0c737a5b207782ac9a0a7eb89089333cfd0129308d"
  end

  # work around ld not understanding --version-script argument
  # upstream bug: https://bugzilla.gnome.org/show_bug.cgi?id=708257
  patch :DATA

  def install
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


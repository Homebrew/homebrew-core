class Gcab < Formula
  desc "Windows installer (.MSI) tool"
  homepage "https://wiki.gnome.org/msitools"
  url "https://download.gnome.org/sources/gcab/1.1/gcab-1.1.tar.xz"
  sha256 "192b2272c2adfde43595e5c62388854bca8a404bc796585b638e81774dd62950"

  bottle do
    sha256 "98f56ce0d3a6aa3e463ff3db4648b35bb50cc28a3ca6c851674def6277ef431a" => :high_sierra
    sha256 "7301b501634551391a4c7070a84bb61586261c76291e4e190cb42ef4091be18e" => :sierra
    sha256 "b85cf8a03bd289713ebe25c269fef51819de959d56a30c8885ab7c185a55e7f5" => :el_capitan
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


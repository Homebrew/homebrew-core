class Graphene < Formula
  desc "Thin layer of graphic data types"
  homepage "https://ebassi.github.io/graphene/"
  url "https://download.gnome.org/sources/graphene/1.8/graphene-1.8.6.tar.xz"
  sha256 "82a07f188d34eb69df4b087b5e1d66e918475f59f7e62fb0308e2c91432a712f"

  bottle do
    sha256 "c01711d7053a1f6afdbf3a7c7897fecfac381c5c6e3bdb70d17d7022a7ba8c2a" => :mojave
    sha256 "bc7565a6e02e0b73b4eda321b6a473c6999e6cdfb26c68b97ac0c1926d97c2fd" => :high_sierra
    sha256 "370975de026735c02592df6f779e2b2599f331352cd951877ef28441ba83390a" => :sierra
    sha256 "37754eee73a297cefd43828934cfccbe4098016f2b0aee02f9d32297717ec1d9" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "glib"

  # patch submitted upstream at https://github.com/ebassi/graphene/pull/146
  patch :DATA

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <graphene-gobject.h>

      int main(int argc, char *argv[]) {
      GType type = graphene_point_get_type();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/graphene-1.0
      -I#{lib}/graphene-1.0/include
      -L#{lib}
      -lgraphene-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/meson.build b/meson.build
index 67e3ad0..b045a54 100644
--- a/meson.build
+++ b/meson.build
@@ -35,7 +35,11 @@ graphene_binary_age = 100 * graphene_minor_version + graphene_micro_version

 # Maintain compatibility with the previous libtool versioning
 soversion = 0
-libversion = '@0@.@1@.@2@'.format(soversion, graphene_binary_age - graphene_interface_age, graphene_interface_age)
+current = graphene_binary_age - graphene_interface_age
+revision = graphene_interface_age
+libversion = '@0@.@1@.@2@'.format(soversion, current, revision)
+
+darwin_versions = [current + 1, '@0@.@1@'.format(current + 1, revision)]

 # Paths
 graphene_prefix = get_option('prefix')
@@ -117,11 +121,6 @@ if host_system == 'linux'
   common_ldflags += cc.get_supported_link_arguments(ldflags)
 endif

-# Maintain compatibility with Autotools on macOS
-if host_system == 'darwin'
-  common_ldflags += [ '-compatibility_version 1', '-current_version 1.0', ]
-endif
-
 # Required dependencies
 mathlib = cc.find_library('m', required: false)
 threadlib = dependency('threads')
diff --git a/src/meson.build b/src/meson.build
index 0d3970f..942c188 100644
--- a/src/meson.build
+++ b/src/meson.build
@@ -112,6 +112,7 @@ libgraphene = library(
   sources: sources + simd_sources + private_headers,
   version: libversion,
   soversion: soversion,
+  darwin_versions: darwin_versions,
   install: true,
   dependencies: [ mathlib, threadlib ] + platform_deps,
   c_args: extra_args + common_cflags + debug_flags + [

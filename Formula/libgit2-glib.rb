class Libgit2Glib < Formula
  desc "Glib wrapper library around libgit2 git access library"
  homepage "https://github.com/GNOME/libgit2-glib"
  url "https://download.gnome.org/sources/libgit2-glib/0.27/libgit2-glib-0.27.8.tar.xz"
  sha256 "c199d69efd69e27e38a650d78357a135f961501d734967bc8c449064dce31935"
  head "https://github.com/GNOME/libgit2-glib.git"

  bottle do
    sha256 "2a8850fb76314cbb73134d4c2fc73a745fe4bb3b5ebc889d902ffb70e9b104b4" => :mojave
    sha256 "6ca7108fd8a692ba5a9ebc480f9bb49b33bc0a154057e595a40baa543690bade" => :high_sierra
    sha256 "0d44665ecaa51f237ed56445dd415833addc1be0b95b33f069d47b23fcd55cee" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libgit2"

  # submitted upstream as https://gitlab.gnome.org/GNOME/libgit2-glib/merge_requests/16
  patch :DATA

  # fixes compilation error
  patch do
    url "https://gitlab.gnome.org/GNOME/libgit2-glib/commit/10da7624b3b2d786b602037cec66e22ee4e7dc13.patch"
    sha256 "16ebcfa89594dd1c2b83950b9fba8636581bd4a6ad4c68b48237fc3fddb5f562"
  end

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}",
                      "-Dpython=false",
                      "-Dvapi=true",
                      ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
      libexec.install Dir["examples/*"]
    end
  end

  test do
    mkdir "horatio" do
      system "git", "init"
    end
    system "#{libexec}/general", testpath/"horatio"
  end
end

__END__
diff --git a/libgit2-glib/meson.build b/libgit2-glib/meson.build
index a6cb0c4..9158178 100644
--- a/libgit2-glib/meson.build
+++ b/libgit2-glib/meson.build
@@ -205,21 +205,15 @@ platform_deps = [
   libgit2_dep,
 ]

-if cc.get_id() == 'msvc'
-  libgit2_glib_link_args = []
-else
-  libgit2_glib_link_args = ['-Wl,-Bsymbolic-functions']
-endif
-
 libgit2_glib = shared_library(
   'git2-glib-' + libgit2_glib_api_version,
   version: libversion,
   soversion: soversion,
+  darwin_versions: darwin_versions,
   sources: sources + enum_sources,
   include_directories: top_inc,
   dependencies: platform_deps,
   c_args: cflags + ['-DG_LOG_DOMAIN="@0@"'.format(libgit2_glib_ns)],
-  link_args: libgit2_glib_link_args,
   install: true,
 )

diff --git a/meson.build b/meson.build
index 29d73ce..b24c268 100644
--- a/meson.build
+++ b/meson.build
@@ -35,6 +35,7 @@ soversion = 0
 current = libgit2_glib_minor_version * 100 + libgit2_glib_micro_version - libgit2_glib_interface_age
 revision = libgit2_glib_interface_age
 libversion = '@0@.@1@.@2@'.format(soversion, current, revision)
+darwin_versions = [current + 1, '@0@.@1@'.format(current + 1, revision)]

 libgit2_glib_prefix = get_option('prefix')
 libgit2_glib_libdir = get_option('libdir')
@@ -106,6 +107,11 @@ endif

 add_project_arguments(common_flags, language: 'c')

+if cc.has_link_argument('-Wl,-Bsymbolic-functions')
+  add_project_link_arguments('-Wl,-Bsymbolic-functions', language : 'c')
+endif
+
+
 # Termios
 have_termios = cc.has_header('termios.h')

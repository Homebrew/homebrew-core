class GnomeLatex < Formula
  desc "LaTeX editor for the GNOME desktop"
  homepage "https://wiki.gnome.org/Apps/LaTeXila"
  url "https://download.gnome.org/sources/gnome-latex/3.28/gnome-latex-3.28.0.tar.xz"
  sha256 "5d489869f7f0b7078071cc6957c25a46e42ad3e3a1cb71b787618a4d28fe359f"

  bottle do
    sha256 "692f383ca261bea02b2853ee77ae398a8efcbb666b25ae758d087f7d1b96263d" => :high_sierra
    sha256 "b95d43825b9d4844db8bfc709c61fa447b56c36e7fa5c8b225890044433d1375" => :sierra
    sha256 "bae5d366a89baaaff691c8bd178092b2b953f6fcd6ea7689aae154fcb15ede60" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "gspell"
  depends_on "tepl"
  depends_on "libgee"
  depends_on "adwaita-icon-theme"
  depends_on "gnome-themes-standard" => :optional

  # see https://gitlab.gnome.org/GNOME/gnome-latex/merge_requests/11
  patch :DATA

  def install
    system "autoreconf", "-fi"
    system "./configure", "--disable-schemas-compile",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
    # HighContrast is provided by gnome-themes-standard
    if File.file?("#{HOMEBREW_PREFIX}/share/icons/HighContrast/.icon-theme.cache")
      system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/HighContrast"
    end
  end

  test do
    system "#{bin}/gnome-latex", "--version"
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index 5769bd5..26e9669 100644
--- a/configure.ac
+++ b/configure.ac
@@ -109,10 +109,23 @@ PKG_CHECK_MODULES([DEP], [
	tepl-4 >= ${TEPL_REQUIRED_VERSION}
	gspell-1 >= ${GSPELL_REQUIRED_VERSION}
	gee-0.8 >= ${GEE_REQUIRED_VERSION}
-	dconf
	gsettings-desktop-schemas
 ])

+AC_ARG_ENABLE([dconf_migration],[AS_HELP_STRING([--disable-dconf-migration],[do not add support for dconf migration])],[enable_dconf_migration=$enableval],[enable_dconf_migration=check])
+FOUND_DCONF_MIGRATION=
+if test x$enable_dconf_migration != xno ; then
+	PKG_CHECK_MODULES([DCONF_DEP], [dconf], [
+		FOUND_DCONF_MIGRATION=yes
+		AC_DEFINE([HAVE_DCONF_MIGRATION], [], [Enable DConf migration support])
+		], [FOUND_DCONF_MIGRATION=no])
+	if test x$enable_dconf_migration = xyes && test x$FOUND_DCONF_MIGRATION = xno ; then
+		AC_MSG_ERROR([Enabling dconf migration support requires the presence of dconf])
+	fi
+fi
+
+AM_CONDITIONAL([DCONF_MIGRATION_BUILD], [test x$FOUND_DCONF_MIGRATION = xyes])
+
 # Native Language Support
 AX_REQUIRE_DEFINED([IT_PROG_INTLTOOL])
 IT_PROG_INTLTOOL([0.50.1])
diff --git a/src/liblatexila/Makefile.am b/src/liblatexila/Makefile.am
index de28d9b..bf7cb07 100644
--- a/src/liblatexila/Makefile.am
+++ b/src/liblatexila/Makefile.am
@@ -7,6 +7,7 @@ liblatexila_la_CPPFLAGS =		\

 liblatexila_la_CFLAGS =			\
	$(DEP_CFLAGS)			\
+	$(DCONF_DEP_CFLAGS)		\
	$(WARN_CFLAGS)			\
	$(CODE_COVERAGE_CFLAGS)		\
	-I$(top_builddir)/src/evince
@@ -16,6 +17,7 @@ liblatexila_la_LDFLAGS = \

 liblatexila_la_LIBADD =		\
	$(DEP_LIBS)		\
+	$(DCONF_DEP_LIBS)	\
	$(CODE_COVERAGE_LIBS)	\
	../evince/libevince.la

@@ -64,15 +66,25 @@ liblatexila_public_c_files =			\
	$(NULL)

 liblatexila_private_headers =			\
-	dh-dconf-migration.h			\
	latexila-templates-common.h		\
	$(NULL)

+if DCONF_MIGRATION_BUILD
+liblatexila_private_headers +=			\
+	dh-dconf-migration.h			\
+	$(NULL)
+endif
+
 liblatexila_private_c_files =			\
-	dh-dconf-migration.c			\
	latexila-templates-common.c		\
	$(NULL)

+if DCONF_MIGRATION_BUILD
+liblatexila_private_c_files +=			\
+	dh-dconf-migration.c			\
+	$(NULL)
+endif
+
 liblatexila_public_built_sources =	\
	latexila-enum-types.c		\
	latexila-enum-types.h		\
diff --git a/src/liblatexila/latexila-utils.c b/src/liblatexila/latexila-utils.c
index 82e2ed6..9f107e0 100644
--- a/src/liblatexila/latexila-utils.c
+++ b/src/liblatexila/latexila-utils.c
@@ -30,9 +30,12 @@
  * Various utility functions.
  */

+#include "config.h"
 #include "latexila-utils.h"
 #include <string.h>
+#ifdef HAVE_DCONF_MIGRATION
 #include "dh-dconf-migration.h"
+#endif
 #include "latexila-synctex.h"

 static gint
@@ -493,6 +496,8 @@ latexila_utils_join_widgets (GtkWidget *widget_top,
 static void
 migrate_latexila_to_gnome_latex_gsettings (void)
 {
+
+#ifdef HAVE_DCONF_MIGRATION
	DhDconfMigration *migration;
	gint i;

@@ -562,6 +567,9 @@ migrate_latexila_to_gnome_latex_gsettings (void)
	}

	_dh_dconf_migration_free (migration);
+#else
+	g_warning("dconf migration not supported!");
+#endif
 }

 static void

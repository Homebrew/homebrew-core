class Gobby < Formula
  desc "Multi-platform collaborative text editor"
  homepage "https://gobby.github.io/"
  url "http://releases.0x539.de/gobby/gobby-0.5.0.tar.gz"
  sha256 "8ceb3598d27cfccdf9c9889b781c4c5c8e1731ca6beb183f5d4555644c06bd98"
  revision 7
  head "https://github.com/gobby/gobby"

  bottle do
    sha256 "7c07581eadd99f56234659ecfb77b710a01bda15a549e191f7b85fd28cea9a72" => :catalina
    sha256 "18ff50e9a89c3adf2b00420158fe03a2aff057bd7200939efdec274c80490fa6" => :mojave
    sha256 "a705fb9ad205268ff01a4cb23dce91f04dee41720f5ed7276106ac76cdb304c0" => :high_sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "gsasl"
  depends_on "gtkmm3"
  depends_on "gtksourceview3"
  depends_on "hicolor-icon-theme"
  depends_on "libinfinity"
  depends_on "libxml++"

  # Necessary to remove mandatory gtk-mac-integration
  # it's badly broken as it depends on an ancient version of ige-mac-integration
  # since it depends on gtk3, it doesn't even need gtk-mac-integration anymore
  # This has already been fixed upstream: gtk2 support has been dropped completely
  # and all traces of ige-mac-integration have been removed from the code
  patch :DATA

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-gtk3"
    system "make", "install"
  end

  test do
    # executable (GUI)
    system bin/"gobby-0.5", "--version"
  end
end
__END__
diff --git a/code/core/header.cpp b/code/core/header.cpp
index eba2fb1..510608e 100644
--- a/code/core/header.cpp
+++ b/code/core/header.cpp
@@ -24,10 +24,6 @@
 #include <gtksourceview/gtksourcelanguage.h>
 #include <gdk/gdkkeysyms.h>

-#ifdef PLATFORM_OSX_NATIVE
-#include <ige-mac-menu.h>
-#endif
-
 namespace {
	Glib::ustring ui_desc =
		"<ui>"
@@ -519,28 +515,7 @@ Gobby::Header::Header(Preferences& preferences,
		);
	}

-#ifdef PLATFORM_OSX_NATIVE
-	ige_mac_menu_set_menu_bar(GTK_MENU_SHELL(m_menubar->gobj()));
-
-	ige_mac_menu_set_quit_menu_item(GTK_MENU_ITEM(
-		m_ui_manager->get_widget(
-			"/MenuMainBar/MenuFile/FileQuit")->gobj()));
-
-	ige_mac_menu_add_app_menu_item(
-		ige_mac_menu_add_app_menu_group(), GTK_MENU_ITEM(
-			m_ui_manager->get_widget(
-				"/MenuMainBar/MenuHelp/HelpAbout")->gobj()),
-		NULL);
-
-	 ige_mac_menu_add_app_menu_item(
-	 	ige_mac_menu_add_app_menu_group(), GTK_MENU_ITEM(
-			m_ui_manager->get_widget(
-				"/MenuMainBar/MenuEdit/EditPreferences")
-			->gobj()),
-		NULL);
-#else
	pack_start(*m_menubar, Gtk::PACK_SHRINK);
-#endif
	pack_start(*m_toolbar, Gtk::PACK_SHRINK);

	m_toolbar->set_toolbar_style(preferences.appearance.toolbar_style);
diff --git a/configure b/configure
index 7dabb26..0987444 100755
--- a/configure
+++ b/configure
@@ -4955,7 +4955,7 @@ $as_echo "#define PLATFORM_OSX 1" >>confdefs.h

 $as_echo "#define PLATFORM_OSX_NATIVE 1" >>confdefs.h

-    required_libs="$required_libs ige-mac-integration"
+    required_libs="$required_libs"
   fi
 fi
 cat >confcache <<\_ACEOF

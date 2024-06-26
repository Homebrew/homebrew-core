class GnomeBuilder < Formula
  desc "Develop software for GNOME"
  homepage "https://apps.gnome.org/Builder"
  url "https://download.gnome.org/sources/gnome-builder/46/gnome-builder-46.2.tar.xz"
  sha256 "0c857b89003b24787f2b1d2aae12d275a074c6684b48803b48c00276d9371963"
  license "GPL-3.0-or-later"

  head do
    url "https://gitlab.gnome.org/GNOME/gnome-builder.git", branch: "main"
    depends_on "gom"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "gettext" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "portal" => :build
  depends_on "vala" => :build
  depends_on "cmark"
  depends_on "editorconfig"
  depends_on "enchant"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "gtk4"
  depends_on "gtksourceview5"
  depends_on "json-glib"
  depends_on "jsonrpc-glib"
  depends_on "libadwaita"
  depends_on "libgit2-glib"
  depends_on "libpanel"
  depends_on "libpeas"
  depends_on "llvm"
  depends_on "template-glib"
  depends_on "vte3"

  # Fixes compilation failure on Linux. See:
  # https://gitlab.gnome.org/GNOME/gnome-builder/-/issues/2176
  resource "libdex" do
    url "https://download.gnome.org/sources/libdex/0.6/libdex-0.6.1.tar.xz"
    sha256 "d176de6578571e32a8c0b603b6a5a13fa5f87fb6b5442575b38ec5af16b17a92"
    # Fixes compilation failure on x86_64 macOS 14, should be fixed in next
    # version. See: https://gitlab.gnome.org/GNOME/libdex/-/issues/19
    patch "diff --git a/src/amd64-ucontext.h b/src/amd64-ucontext.h
index 9a4820c..d96a1a8 100644
--- a/src/amd64-ucontext.h
+++ b/src/amd64-ucontext.h
@@ -3,10 +3,30 @@
 typedef struct mcontext mcontext_t;
 typedef struct ucontext ucontext_t;
 
-extern  int   swapcontext(ucontext_t*, const ucontext_t*);
-extern  void  makecontext(ucontext_t*, void(*)(void), int, ...);
-extern  int   getmcontext(mcontext_t*);
-extern  void  setmcontext(const mcontext_t*);
+#define _DEX_RESTRICT
+#define _DEX_VOID void
+#define _DEX_UCONTEXT_EXTERN extern
+
+#if defined(__APPLE__)
+# include <AvailabilityMacros.h>
+# if defined(MAC_OS_X_VERSION_10_14)
+#  undef _DEX_RESTRICT
+#  define _DEX_RESTRICT __restrict
+#  undef _DEX_VOID
+#  define _DEX_VOID
+#  undef _DEX_UCONTEXT_EXTERN
+#  define _DEX_UCONTEXT_EXTERN
+# endif
+#endif
+
+_DEX_UCONTEXT_EXTERN int  swapcontext(ucontext_t* _DEX_RESTRICT, const ucontext_t* _DEX_RESTRICT);
+_DEX_UCONTEXT_EXTERN void makecontext(ucontext_t*, void(*)(_DEX_VOID), int, ...);
+_DEX_UCONTEXT_EXTERN int  getmcontext(mcontext_t*);
+_DEX_UCONTEXT_EXTERN void setmcontext(const mcontext_t*);
+
+#undef _DEX_RESTRICT
+#undef _DEX_VOID
+#undef _DEX_UCONTEXT_EXTERN
 
 /*-
  * Copyright (c) 1999 Marcel Moolenaar
"
  end

  patch do
    on_linux do
      url "https://gitlab.gnome.org/GNOME/gnome-builder/uploads/3595cbe09fb9dd41d558a317251ca356/gdkrgba.patch"
      sha256 "5234eb22edba53a6977cd1ed9c0de667115c65bb25ddb3ce3cd7cb43cdd7592f"
    end
  end

  # Prevents Meson from compiling schemas / updating icon cache separately from
  # other GTK programs. We want to compile schemas / update icon cache all
  # together
  patch "diff --git a/meson.build b/meson.build
index e486d52..39afd1d 100644
--- a/meson.build
+++ b/meson.build
@@ -388,8 +388,8 @@ subdir('po')
 subdir('doc')

 gnome.post_install(
-  glib_compile_schemas: true,
-  gtk_update_icon_cache: true,
+  glib_compile_schemas: false,
+  gtk_update_icon_cache: false,
   update_desktop_database: true,
 )"

  def install
    resource("libdex").stage do
      system "meson", "setup", "build", *std_meson_args
      system "meson", "compile", "-C", "build", "--verbose"
      system "meson", "install", "-C", "build"

      ENV.prepend_path "PKG_CONFIG_PATH", lib/"pkgconfig"
      ENV.prepend_path "GI_GIR_PATH", share/"gir-1.0"
    end

    args = %w[
      -Dplugin_dspy=false
      -Dplugin_flatpak=false
      -Dplugin_html_preview=false
      -Dplugin_markdown_preview=false
      -Dplugin_sphinx_preview=false
      -Dplugin_update_manager=false
      -Dwebkit=disabled
    ]

    # This plugin fails to compile in 46.2, should be fixed in later versions
    args << "-Dplugin_git=false" unless build.head?
    # This plugin does not exist in 46.2, but on head it does and requires
    # WebKit
    args << "-Dplugin_manuals=false" if build.head?

    system "meson",
      "setup",
      "build",
      *args,
      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  # See patch comment on line 87
  def post_install
    system Formula["glib"].opt_bin/"glib-compile-schemas", HOMEBREW_PREFIX/"share/glib-2.0/schemas"
    system Formula["gtk4"].opt_bin/"gtk4-update-icon-cache", "-qtf", HOMEBREW_PREFIX/"share/icons/hicolor"
  end

  test do
    assert_equal "GNOME Builder #{version}", shell_output("#{bin}/gnome-builder --version").strip
  end
end

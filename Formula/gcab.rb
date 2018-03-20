class Gcab < Formula
  desc "Windows installer (.MSI) tool"
  homepage "https://wiki.gnome.org/msitools"
  url "https://download.gnome.org/sources/gcab/0.7/gcab-0.7.tar.xz"
  sha256 "a16e5ef88f1c547c6c8c05962f684ec127e078d302549f3dfd2291e167d4adef"
  revision 1

  bottle do
    sha256 "98f56ce0d3a6aa3e463ff3db4648b35bb50cc28a3ca6c851674def6277ef431a" => :high_sierra
    sha256 "7301b501634551391a4c7070a84bb61586261c76291e4e190cb42ef4091be18e" => :sierra
    sha256 "b85cf8a03bd289713ebe25c269fef51819de959d56a30c8885ab7c185a55e7f5" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gettext"
  depends_on "glib"

  # work around ld not understanding --version-script argument
  # upstream bug: https://bugzilla.gnome.org/show_bug.cgi?id=708257
  patch :DATA

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

__END__
diff --git a/Makefile.in b/Makefile.in
index 2264c17..7782d62 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -474,7 +474,7 @@ libgcab_1_0_la_CPPFLAGS = \
 libgcab_1_0_la_LIBADD = -lz $(GLIB_LIBS)
 libgcab_1_0_la_LDFLAGS = \
 	-version-info 0:0:0				\
-	-Wl,--version-script=${srcdir}/libgcab.syms	\
+	-Wl                                     	\
 	-no-undefined					\
 	$(NULL)


class Libgda < Formula
  desc "Provides unified data access to the GNOME project"
  homepage "http://www.gnome-db.org/"
  url "https://download.gnome.org/sources/libgda/5.2/libgda-5.2.5.tar.xz"
  sha256 "e3d2e4c28c08a22efd520767fa9d16e92cc1821f693261d7cb2892cc23ec90c8"

  bottle do
    sha256 "c8e13219f324e8398a33dbf0b7aaf9ae1385dc42971af89013f0c71a1606a1ae" => :mojave
    sha256 "39e348596409d69d57609d0a00c6e9506a9fd52a4f90e585e3b6840bf03ea67e" => :high_sierra
    sha256 "e165830cedc3a0955989746145b310cc03fe96b84f18b33c4c3f2b827bdd473c" => :sierra
    sha256 "7809bb97ebcd233a740c1e5b5cb0f291a902639a6479d5e53fdcfedd928b6582" => :el_capitan
    sha256 "01e46f8673fcf3fad0bccdd70e9bd6fac08f0f5b7035e85318a3add4db329a9b" => :yosemite
  end

  # bug reported at https://gitlab.gnome.org/GNOME/libgda/issues/142
  patch :DATA

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libgcrypt"
  depends_on "openssl"
  depends_on "readline"
  depends_on "sqlite"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-binreloc",
                          "--disable-gtk-doc",
                          "--without-java",
                          "--enable-introspection",
                          "--enable-gi-system-install=no"
    system "make"
    system "make", "install"
  end
end

__END__
diff --git a/libgda/sqlite/virtual/gda-vprovider-data-model.c b/libgda/sqlite/virtual/gda-vprovider-data-model.c
index d6674de..31c7993 100644
--- a/libgda/sqlite/virtual/gda-vprovider-data-model.c
+++ b/libgda/sqlite/virtual/gda-vprovider-data-model.c
@@ -280,7 +280,7 @@ virtual_filtered_data_free (VirtualFilteredData *data)
 static VirtualFilteredData *
 virtual_filtered_data_ref (VirtualFilteredData *data)
 {
-	g_return_if_fail (data != NULL);
+	g_return_val_if_fail (data != NULL, NULL);
 	data->refcount ++;
 	return data;
 }


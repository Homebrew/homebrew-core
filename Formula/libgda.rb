class Libgda < Formula
  desc "Provides unified data access to the GNOME project"
  homepage "http://www.gnome-db.org/"
  url "https://download.gnome.org/sources/libgda/5.2/libgda-5.2.5.tar.xz"
  sha256 "e3d2e4c28c08a22efd520767fa9d16e92cc1821f693261d7cb2892cc23ec90c8"

  bottle do
    sha256 "6dc574ad6963f7779266af499e740d663fd70d26dd3e3212c57cdc556abc7060" => :mojave
    sha256 "ba273939064c8f4e4adc764660888e80b9be67486554dd25e00f5d941a0c0c0f" => :high_sierra
    sha256 "2183cd2116b161091c1a421a3e584064a754ab11f7838dbba9e5ece6b13fc3af" => :sierra
  end

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

  # Bug reported at https://gitlab.gnome.org/GNOME/libgda/issues/142
  patch :DATA

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

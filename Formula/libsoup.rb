class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://wiki.gnome.org/Projects/libsoup"
  url "https://download.gnome.org/sources/libsoup/2.66/libsoup-2.66.0.tar.xz"
  sha256 "51adc2ad6c8c670cf6339fcfa88190a3b58135a9cddd21f623a0f80fdb9c8921"

  bottle do
    sha256 "0985faab169911df166b2c0c13ea5056458ac8042d8d6f405138f8d8079710a8" => :mojave
    sha256 "f1eaee335bc250297fb792b387f094d7b95308fbe2b33677ea3d424e6b0cc38b" => :high_sierra
    sha256 "f757e54086c6cf791c8226fb0987180c8ad1c3b2b054ca37e4eba69d982b6c85" => :sierra
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib-networking"
  depends_on "gnutls"
  depends_on "libpsl"
  depends_on "vala"

  # submitted upstream as https://gitlab.gnome.org/GNOME/libsoup/merge_requests/49
  patch :DATA

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end

    # to be removed when https://gitlab.gnome.org/GNOME/gobject-introspection/issues/222 is fixed
    %w[Soup-2.4 SoupGNOME-2.4].each do |gir|
      inreplace share/"gir-1.0/#{gir}.gir", "@rpath", lib.to_s
      system "g-ir-compiler", "--includedir=#{share}/gir-1.0", "--output=#{lib}/girepository-1.0/#{gir}.typelib", share/"gir-1.0/#{gir}.gir"
    end
  end

  test do
    # if this test start failing, the problem might very well be in glib-networking instead of libsoup
    (testpath/"test.c").write <<~EOS
      #include <libsoup/soup.h>

      int main(int argc, char *argv[]) {
        SoupMessage *msg = soup_message_new("GET", "https://brew.sh");
        SoupSession *session = soup_session_new();
        soup_session_send_message(session, msg); // blocks
        g_assert_true(SOUP_STATUS_IS_SUCCESSFUL(msg->status_code));
        g_object_unref(msg);
        g_object_unref(session);
        return 0;
      }
    EOS
    ENV.libxml2
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/libsoup-2.4
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lsoup-2.4
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
__END__
diff --git a/libsoup/meson.build b/libsoup/meson.build
index 5f2a215..92b615f 100644
--- a/libsoup/meson.build
+++ b/libsoup/meson.build
@@ -229,6 +229,7 @@ libsoup = library('soup-@0@'.format(apiversion),
   soup_enums,
   version : libversion,
   soversion : soversion,
+  darwin_versions: darwin_versions,
   c_args : libsoup_c_args + hidden_visibility_flag,
   include_directories : configinc,
   install : true,
@@ -260,6 +261,7 @@ if enable_gnome
     soup_gnome_sources + soup_gnome_headers,
     version : libversion,
     soversion : soversion,
+    darwin_versions: darwin_versions,
     c_args : libsoup_c_args + hidden_visibility_flag,
     include_directories : configinc,
     install : true,
diff --git a/meson.build b/meson.build
index a979362..e4c5d75 100644
--- a/meson.build
+++ b/meson.build
@@ -1,6 +1,6 @@
 project('libsoup', 'c',
         version: '2.66.0',
-        meson_version : '>=0.47',
+        meson_version : '>=0.48',
         license : 'LGPL2',
         default_options : 'c_std=c89')

@@ -16,6 +16,11 @@ libversion = '1.8.0'
 apiversion = '2.4'
 soversion = '1'
 libsoup_api_name = '@0@-@1@'.format(meson.project_name(), apiversion)
+libversion_arr = libversion.split('.')
+darwin_version_major = libversion_arr[0].to_int()
+darwin_version_minor = libversion_arr[1].to_int()
+darwin_version_micro = libversion_arr[2].to_int()
+darwin_versions = [darwin_version_major + darwin_version_minor + 1, '@0@.@1@'.format(darwin_version_major + darwin_version_minor + 1, darwin_version_micro)]

 host_system = host_machine.system()

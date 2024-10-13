class Libgee < Formula
  desc "Collection library providing GObject-based interfaces"
  homepage "https://wiki.gnome.org/Projects/Libgee"
  url "https://download.gnome.org/sources/libgee/0.20/libgee-0.20.6.tar.xz"
  sha256 "1bf834f5e10d60cc6124d74ed3c1dd38da646787fbf7872220b8b4068e476d4d"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "2e94fefbe95465772e0676f4d0f65ae212867caeaf659921e069ae1f153e5c4e"
    sha256 cellar: :any,                 arm64_sonoma:   "0f3ac7bcee7e8a3ef342362cc6fb67c7f20f6e616ccaebe0b6d187069498f559"
    sha256 cellar: :any,                 arm64_ventura:  "648c253edc216944b0e678393a1376050dce9c2136a2e23543e0c2c399d9c27b"
    sha256 cellar: :any,                 arm64_monterey: "4db78ce506f169e6cf5e958f3fe5b53b53cd8b89658b27177021d38446705ec1"
    sha256 cellar: :any,                 sonoma:         "81a4559f30db3797dc6f91af8e0cc639814ddbb36a625fdfcaad51de153a7990"
    sha256 cellar: :any,                 ventura:        "49e93aa588f553b9781e84a7e9e0e9fe2dcb511976218ef2385983da6e318d67"
    sha256 cellar: :any,                 monterey:       "1514560672301f3b58ea438cbe537af7e878b0def106674bee39f022902a2508"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfcece11cd71b887bf40f1ea11e69d2fdb14133ae914b1d67858213b6e49fe0c"
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build

  depends_on "glib"

  on_macos do
    depends_on "gettext"
  end

  # incompatible function pointer types build patch
  # upstream bug report, https://gitlab.gnome.org/GNOME/libgee/-/issues/47
  patch :DATA

  def install
    # ensures that the gobject-introspection files remain within the keg
    inreplace "gee/Makefile.in" do |s|
      s.gsub! "@HAVE_INTROSPECTION_TRUE@girdir = @INTROSPECTION_GIRDIR@",
              "@HAVE_INTROSPECTION_TRUE@girdir = $(datadir)/gir-1.0"
      s.gsub! "@HAVE_INTROSPECTION_TRUE@typelibdir = @INTROSPECTION_TYPELIBDIR@",
              "@HAVE_INTROSPECTION_TRUE@typelibdir = $(libdir)/girepository-1.0"
    end

    system "./configure", *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gee.h>

      int main(int argc, char *argv[]) {
        GType type = gee_traversable_stream_get_type();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/gee-0.8
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgee-0.8
      -lglib-2.0
      -lgobject-2.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/gee/hashmap.c b/gee/hashmap.c
index a9aabdf..7e7e278 100644
--- a/gee/hashmap.c
+++ b/gee/hashmap.c
@@ -4086,7 +4086,7 @@ gee_hash_map_map_iterator_gee_map_iterator_interface_init (GeeMapIteratorIface *
 	iface->next = (gboolean (*) (GeeMapIterator*)) gee_hash_map_node_iterator_next;
 	iface->has_next = (gboolean (*) (GeeMapIterator*)) gee_hash_map_node_iterator_has_next;
 	iface->get_mutable = gee_hash_map_map_iterator_real_get_mutable;
-	iface->get_read_only = gee_hash_map_map_iterator_real_get_read_only;
+	iface->get_read_only = (gboolean (*) (GeeMapIterator*)) gee_hash_map_map_iterator_real_get_read_only;
 	iface->get_valid = (gboolean (*) (GeeMapIterator *)) gee_hash_map_node_iterator_get_valid;
 }

diff --git a/gee/treemap.c b/gee/treemap.c
index af3233b..40504b8 100644
--- a/gee/treemap.c
+++ b/gee/treemap.c
@@ -13955,7 +13955,7 @@ gee_tree_map_map_iterator_gee_map_iterator_interface_init (GeeMapIteratorIface *
 	iface->next = (gboolean (*) (GeeMapIterator*)) gee_tree_map_node_iterator_next;
 	iface->has_next = (gboolean (*) (GeeMapIterator*)) gee_tree_map_node_iterator_has_next;
 	iface->unset = (void (*) (GeeMapIterator*)) gee_tree_map_node_iterator_unset;
-	iface->get_read_only = gee_tree_map_map_iterator_real_get_read_only;
+	iface->get_read_only = (gboolean (*) (GeeMapIterator*)) gee_tree_map_map_iterator_real_get_read_only;
 	iface->get_mutable = gee_tree_map_map_iterator_real_get_mutable;
 	iface->get_valid = (gboolean (*) (GeeMapIterator *)) gee_tree_map_node_iterator_get_valid;
 }
@@ -14320,7 +14320,7 @@ gee_tree_map_sub_map_iterator_gee_map_iterator_interface_init (GeeMapIteratorIfa
 	iface->next = (gboolean (*) (GeeMapIterator*)) gee_tree_map_sub_node_iterator_next;
 	iface->has_next = (gboolean (*) (GeeMapIterator*)) gee_tree_map_sub_node_iterator_has_next;
 	iface->unset = (void (*) (GeeMapIterator*)) gee_tree_map_sub_node_iterator_unset;
-	iface->get_read_only = gee_tree_map_sub_map_iterator_real_get_read_only;
+	iface->get_read_only = (gboolean (*) (GeeMapIterator*)) gee_tree_map_sub_map_iterator_real_get_read_only;
 	iface->get_mutable = gee_tree_map_sub_map_iterator_real_get_mutable;
 	iface->get_valid = (gboolean (*) (GeeMapIterator *)) gee_tree_map_sub_node_iterator_get_valid;
 }
diff --git a/tests/testcase.c b/tests/testcase.c
index 18fdf82..9d6420e 100644
--- a/tests/testcase.c
+++ b/tests/testcase.c
@@ -278,7 +278,7 @@ gee_test_case_add_test (GeeTestCase* self,
 	_tmp3_ = self->priv->suite;
 	_tmp4_ = gee_test_case_adaptor_get_name (adaptor);
 	_tmp5_ = _tmp4_;
-	_tmp6_ = g_test_create_case (_tmp5_, (gsize) 0, adaptor, _gee_test_case_adaptor_set_up_gtest_fixture_func, _gee_test_case_adaptor_run_gtest_fixture_func, _gee_test_case_adaptor_tear_down_gtest_fixture_func);
+	_tmp6_ = g_test_create_case (_tmp5_, (gsize) 0, adaptor, (GTestFixtureFunc *) _gee_test_case_adaptor_set_up_gtest_fixture_func, (GTestFixtureFunc *) _gee_test_case_adaptor_run_gtest_fixture_func, (GTestFixtureFunc *) _gee_test_case_adaptor_tear_down_gtest_fixture_func);
 	g_test_suite_add (_tmp3_, _tmp6_);
 	_gee_test_case_adaptor_unref0 (adaptor);
 	(test_target_destroy_notify == NULL) ? NULL : (test_target_destroy_notify (test_target), NULL);

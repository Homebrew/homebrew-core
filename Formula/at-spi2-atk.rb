class AtSpi2Atk < Formula
  desc "Accessibility Toolkit GTK+ module"
  homepage "https://www.freedesktop.org/wiki/Accessibility/AT-SPI2"
  url "https://download.gnome.org/sources/at-spi2-atk/2.38/at-spi2-atk-2.38.0.tar.xz"
  sha256 "cfa008a5af822b36ae6287f18182c40c91dd699c55faa38605881ed175ca464f"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 x86_64_linux: "f68be9dbb59804bc1f6de1615def3c73bf3b7d994e94844e521806cd5331686d"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "at-spi2-core"
  depends_on "atk"
  depends_on "libxml2"
  depends_on :linux

  def install
    ENV.refurbish_args

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "--libdir=#{lib}", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <string.h>
      #include <stdlib.h>
      #include <glib.h>
      #include <atk/atk.h>
      #include <atk-bridge.h>

      static AtkObject *root_accessible;
      static GMainLoop *mainloop;
      static gchar *tdata_path = NULL;

      AtkObject * test_get_root (void) {
        return root_accessible;
      }

      static AtkObject * get_root (void) {
        return test_get_root ();
      }

      const gchar * get_toolkit_name (void) {
        return strdup ("atspitesting-toolkit");
      }

      static void setup_atk_util (void) {
        AtkUtilClass *klass;

        klass = g_type_class_ref (ATK_TYPE_UTIL);
        klass->get_root = get_root;
        klass->get_toolkit_name = get_toolkit_name;
        g_type_class_unref (klass);
      }

      static GOptionEntry optentries[] = {
        {"test-data-file", 0, 0, G_OPTION_ARG_STRING, &tdata_path, "Path to file of test data", NULL},
        {NULL}
      };

      int main (int argc, char *argv[]) {
        GOptionContext *opt;
        GError *err = NULL;
        opt = g_option_context_new (NULL);
        g_option_context_add_main_entries (opt, optentries, NULL);
        g_option_context_set_ignore_unknown_options (opt, TRUE);

        if (!g_option_context_parse (opt, &argc, &argv, &err))
          g_error("Option parsing failed: %s", err->message);

        setup_atk_util ();
        atk_bridge_adaptor_init (NULL, NULL);

        return 0;
      }
    EOS

    pkg_config_cflags = shell_output("pkg-config --cflags --libs atk-bridge-2.0 glib-2.0 atk").chomp.split
    system ENV.cc, "test.c", *pkg_config_cflags, "-o", "test"
    assert_match "atk_bridge_adaptor_init", shell_output("#{testpath}/test 2>&1")
  end
end

class GnomeOnlineAccounts < Formula
  desc "Single sign-on framework for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gnome-online-accounts"
  url "https://download.gnome.org/sources/gnome-online-accounts/3.54/gnome-online-accounts-3.54.4.tar.xz"
  sha256 "55739943e747dcb4885ea607a4c2767d8002f71295e1affea62ea36f6d1cf593"
  license "LGPL-2.0-or-later"
  head "https://gitlab.gnome.org/GNOME/gnome-online-accounts.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "346423767aca7d97c4972ca05e22061d6f65cb123513a8aeb1c2ee02f0c8e7b2"
    sha256 arm64_sonoma:  "6e569a502d492e34b794ac7bb1359d7aa910e625673553c1d4b680db6b5e1190"
    sha256 arm64_ventura: "3eae0e0b8c34940279819af809185a0251c24ee74865e96360a8282c5d773439"
    sha256 sonoma:        "3705b696d159611156d67b826af4713df4a541f4653ed3fd840d43a9db7aa331"
    sha256 ventura:       "6e5ce2a3c41703d651da38c6a04f4b2568bddfea2caafe3de09b0b23254c9672"
    sha256 arm64_linux:   "c5501ac7264276bcc936c235503085ded8196c39ac20505ee064c263dae43b65"
    sha256 x86_64_linux:  "d1078358c325c28c40e7eab3b2fd9870993bc4eef57fb7a901ef304ba3f0e060"
  end

  depends_on "dbus" => :build
  depends_on "docbook-xsl" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "glib"
  depends_on "gtk4"
  depends_on "json-glib"
  depends_on "libadwaita"
  depends_on "libgoa"
  depends_on "librest"
  depends_on "libsecret"
  depends_on "libsoup"

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "gcr"
    depends_on "keyutils"
    depends_on "krb5"
  end

  def install
    # NOTE: `libgoa` is split out to provide a lightweight formula with minimal dependencies
    inreplace "src/meson.build", /^subdir\('goa'\)$/, "libgoa_dep = dependency(goa_api_name)"
    rm_r("src/goa")

    ENV["DESTDIR"] = "/"
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    args = ["-Ddocumentation=false"]
    args << "-Dkerberos=false" if OS.mac?

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system Formula["glib"].opt_bin/"glib-compile-schemas", HOMEBREW_PREFIX/"share/glib-2.0/schemas"
    system Formula["gtk4"].opt_bin/"gtk4-update-icon-cache", "-f", "-t", HOMEBREW_PREFIX/"share/icons/hicolor"
  end

  test do
    # https://gitlab.gnome.org/GNOME/gnome-online-accounts/-/blob/master/src/examples/list-providers.c
    (testpath/"test.c").write <<~'C'
      #define GOA_API_IS_SUBJECT_TO_CHANGE
      #define GOA_BACKEND_API_IS_SUBJECT_TO_CHANGE
      #include <goabackend/goabackend.h>

      typedef struct {
        GMainLoop *loop;
        GList *providers;
        GError *error;
      } GetAllData;

      static void get_all_cb (GObject *source, GAsyncResult *res, gpointer user_data) {
        GetAllData *data = user_data;
        goa_provider_get_all_finish (&data->providers, res, &data->error);
        g_main_loop_quit (data->loop);
      }

      int main (int argc, char **argv) {
        GetAllData data = {0,};
        GoaProvider *provider;
        GList *l;

        data.loop = g_main_loop_new (NULL, FALSE);
        goa_provider_get_all (get_all_cb, &data);
        g_main_loop_run (data.loop);

        if (data.error != NULL) {
          g_printerr ("Failed to list providers: %s (%s, %d)\n",
              data.error->message,
              g_quark_to_string (data.error->domain),
              data.error->code);
          g_error_free (data.error);
          goto out;
        }

        for (l = data.providers; l != NULL; l = l->next) {
          char *provider_name;

          provider = GOA_PROVIDER (l->data);
          provider_name = goa_provider_get_provider_name (provider, NULL);
          g_print ("%s\n", provider_name);
          g_free (provider_name);
          provider = NULL;
        }

      out:
        g_main_loop_unref (data.loop);
        g_list_free_full (data.providers, g_object_unref);

        return 0;
      }
    C

    providers = ["Google", "WebDAV", "Nextcloud", "Microsoft", "Microsoft Exchange", "IMAP and SMTP"]
    providers << "Kerberos" unless OS.mac?
    providers << "Microsoft 365"

    system ENV.cc, "test.c", "-o", "test", *shell_output("pkgconf --cflags --libs goa-backend-1.0").chomp.split
    assert_equal providers, shell_output("./test").lines(chomp: true)
  end
end

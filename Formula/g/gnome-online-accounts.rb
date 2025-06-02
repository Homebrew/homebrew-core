class GnomeOnlineAccounts < Formula
  desc "Single sign-on framework for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gnome-online-accounts"
  url "https://download.gnome.org/sources/gnome-online-accounts/3.54/gnome-online-accounts-3.54.3.tar.xz"
  sha256 "bcf655dd1ddc22bc25793b6840da19f5cad7ba0b7227ff969ed9c252f036aac5"
  license "LGPL-2.0-or-later"
  head "https://gitlab.gnome.org/GNOME/gnome-online-accounts.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "97747861c4df68bc93c41c69ce040e4dae7f571531aea837df6024d94c585ed4"
    sha256 arm64_sonoma:  "daf640a8bde2b171366725deb9c23ce1996bf959566c3f3e61bc972d96ec4465"
    sha256 arm64_ventura: "1ae7f0190b3dc26f31b653b6a40a8fecf2aa891973ba39cd1542569ab649191f"
    sha256 sonoma:        "cacaa3c753e828206a9e8921c6253154cfdde5e46fc0b2c26460df951b88a617"
    sha256 ventura:       "49772e6a65fda5556c77a978616dd50b7f28a2f4d7d1af434414c45de9a498f2"
    sha256 arm64_linux:   "4c9f7898115b6a111cd713fd3a4040dd1e89869c9f2c529344c5a58de5eca0aa"
    sha256 x86_64_linux:  "8d12dc63d0d64e84c7c79bd64f33c5d7c48d749b66884900451f8683c8db5e66"
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

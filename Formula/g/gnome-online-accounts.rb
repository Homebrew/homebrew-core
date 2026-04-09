class GnomeOnlineAccounts < Formula
  desc "Single sign-on framework for GNOME"
  homepage "https://gitlab.gnome.org/GNOME/gnome-online-accounts"
  url "https://download.gnome.org/sources/gnome-online-accounts/3.58/gnome-online-accounts-3.58.0.tar.xz"
  sha256 "344d4dff9149a1adc4539417193e1eccc2f76ef40ac24e104ccf58072be55999"
  license "LGPL-2.0-or-later"
  head "https://gitlab.gnome.org/GNOME/gnome-online-accounts.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "2ff012c67d2a447bbeece45eca78ae3ca378890226918a4c21104bc2a30ae3b1"
    sha256 arm64_sequoia: "f7b31e9528928f504d637396a69ea88aeb106f385fd912a5b5cf695cc4e2a99d"
    sha256 arm64_sonoma:  "264166ba82934bf5846ea9ad04faa5dd8bf02eb83a13f8783c3cab7988fc0879"
    sha256 sonoma:        "7436127fdbccac45c6f63efcde3a0c9d7c4fa24a59b5ae929893074bc3e9e8d0"
    sha256 arm64_linux:   "bc2a40f73ea524c6811d3c5fa6286ef6b8b2e55b79a34578fc2dc170cd326d2f"
    sha256 x86_64_linux:  "c1844d6614d2ec4169aa9155c4aab1939f2ec60259a29c5b973c5722b0ccc3fc"
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
    depends_on "gettext" => :build
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

    providers = ["Google", "WebDAV", "Nextcloud", "Microsoft Exchange", "IMAP and SMTP"]
    providers << "Kerberos" unless OS.mac?
    providers << "Microsoft 365"

    system ENV.cc, "test.c", "-o", "test", *shell_output("pkgconf --cflags --libs goa-backend-1.0").chomp.split
    assert_equal providers, shell_output("./test").lines(chomp: true)
  end
end

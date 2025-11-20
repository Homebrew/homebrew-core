class Libgoa < Formula
  desc "Single sign-on framework for GNOME - client library"
  homepage "https://gitlab.gnome.org/GNOME/gnome-online-accounts"
  url "https://download.gnome.org/sources/gnome-online-accounts/3.56/gnome-online-accounts-3.56.1.tar.xz"
  sha256 "64459360a3531eb7edee2e03bd5ab77ec95f1051b569e11a479b4f94f405c53f"
  license "LGPL-2.0-or-later"
  head "https://gitlab.gnome.org/GNOME/gnome-online-accounts.git", branch: "master"

  livecheck do
    formula "gnome-online-accounts"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e94df65f46b30b1379c289147bd98b8efeed244abb2379bbcb21fcaa30c645ef"
    sha256 cellar: :any, arm64_sequoia: "5e2d811f4f8f34d49eb8bfa17c82337f236efae5d577d98daae17c2e544fc06d"
    sha256 cellar: :any, arm64_sonoma:  "19af4eec07a37a0753618c1a52de46fdb418011ff1d067edd4fbd0c7e5ff1f92"
    sha256 cellar: :any, sonoma:        "84ce992417b40cf9eeaceeb8a5abd9b320d60f35349a801f40300a5260ea705e"
    sha256               arm64_linux:   "d770e920881dec18e95e94adcc75c34b16de940f59e28452c241b703b64f4808"
    sha256               x86_64_linux:  "b0c2fdc955513cc026413e690dcacce49d9c4ba0aeff18da783a8a8b1d9baeac"
  end

  depends_on "dbus" => [:build, :test]
  depends_on "gobject-introspection" => :build
  depends_on "gtk4" => :build # gtk4-update-icon-cache
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "glib"

  def install
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", "-Ddocumentation=false", "-Dgoabackend=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    # Remove directories that are installed in `gnome-online-accounts`
    rm_r([share/"icons", share/"locale"].select(&:exist?))
  end

  test do
    # https://gitlab.gnome.org/GNOME/gnome-online-accounts/-/blob/master/src/examples/list-accounts.c
    (testpath/"test.c").write <<~'C'
      #define GOA_API_IS_SUBJECT_TO_CHANGE
      #include <goa/goa.h>

      int main (int argc, char **argv) {
        GError *error = NULL;
        GoaClient *client;
        GList *accounts, *l;
        GoaAccount *account;

        client = goa_client_new_sync (NULL, &error);
        if (!client) {
          g_critical ("Could not create GoaClient: %s", error->message);
          return 1;
        }

        accounts = goa_client_get_accounts (client);
        for (l = accounts; l != NULL; l = l->next) {
          GoaOAuth2Based *oauth2 = NULL;

          account = goa_object_get_account (GOA_OBJECT (l->data));
          g_print ("%s at %s (%s)\n",
                   goa_account_get_presentation_identity (account),
                   goa_account_get_provider_name (account),
                   goa_account_get_provider_type (account));
          oauth2 = goa_object_get_oauth2_based (GOA_OBJECT (l->data));
          if (oauth2) {
            gchar *access_token;
            if (goa_oauth2_based_call_get_access_token_sync (oauth2,
                                                             &access_token,
                                                             NULL,
                                                             NULL,
                                                             NULL)) {
              g_print ("\tAccessToken: %s\n", access_token);
              g_free (access_token);
            }
            g_print ("\tClientId: %s\n\tClientSecret: %s\n",
                     goa_oauth2_based_get_client_id (oauth2),
                     goa_oauth2_based_get_client_secret (oauth2));
          }
          g_clear_object (&oauth2);
        }

        g_list_free_full (accounts, (GDestroyNotify) g_object_unref);
        return 0;
      }
    C

    ENV["XDG_DATA_DIRS"] = testpath # avoid loading system dbus services
    ENV["DBUS_SESSION_BUS_ADDRESS"] = address = "unix:path=#{testpath}/bus"
    pid = spawn(Formula["dbus"].bin/"dbus-daemon", "--session", "--nofork", "--address=#{address}")
    sleep 2
    system ENV.cc, "test.c", "-o", "test", *shell_output("pkgconf --cflags --libs goa-1.0").chomp.split
    system "./test"
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end

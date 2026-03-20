class Libgoa < Formula
  desc "Single sign-on framework for GNOME - client library"
  homepage "https://gitlab.gnome.org/GNOME/gnome-online-accounts"
  url "https://download.gnome.org/sources/gnome-online-accounts/3.58/gnome-online-accounts-3.58.0.tar.xz"
  sha256 "344d4dff9149a1adc4539417193e1eccc2f76ef40ac24e104ccf58072be55999"
  license "LGPL-2.0-or-later"
  head "https://gitlab.gnome.org/GNOME/gnome-online-accounts.git", branch: "master"

  livecheck do
    formula "gnome-online-accounts"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2270b2222320c4501f28640a1c4f2ff2b990258606d50f69ec2733b544a29cae"
    sha256 cellar: :any, arm64_sequoia: "32d6ecc3e7bf5093002e79816d43ce8c31d3c9199a86ee358abaa59a0c280f7f"
    sha256 cellar: :any, arm64_sonoma:  "43fb90d701e7b62815e2eb960d6b434713380c7cb9d47c8ac8d3e812541c88b2"
    sha256 cellar: :any, sonoma:        "ab9dcfe0e45c47ea75d478e6f9da82a801f18a7cb8964c86169cd7601756166e"
    sha256               arm64_linux:   "9f215529a7663c3cde297591aaef425a792c1e15958f36515baf84b59060795e"
    sha256               x86_64_linux:  "434ba809d5418015a635668fd384dc7b79b998f2a9f642873441c027e7369f6a"
  end

  depends_on "dbus" => [:build, :test]
  depends_on "docbook-xsl" => :build
  depends_on "gobject-introspection" => :build
  depends_on "gtk4" => :build # gtk4-update-icon-cache
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build

  depends_on "glib"

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "libxml2"

  on_linux do
    depends_on "gettext" => :build
  end

  def install
    ENV["DESTDIR"] = "/"
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "meson", "setup", "build", "-Ddocumentation=false", "-Dgoabackend=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    # Remove assets that are installed in `gnome-online-accounts`
    rm share/"applications/org.gnome.goa-daemon.desktop"
    rm share/"man/man8/goa-daemon.8"
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

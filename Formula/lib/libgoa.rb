class Libgoa < Formula
  desc "Single sign-on framework for GNOME - client library"
  homepage "https://gitlab.gnome.org/GNOME/gnome-online-accounts"
  url "https://download.gnome.org/sources/gnome-online-accounts/3.58/gnome-online-accounts-3.58.1.tar.xz"
  sha256 "9ec1900cc51409c2067c07c828c10be06fe3bf68d2999bb72d7d5ed325ed9bbc"
  license "LGPL-2.0-or-later"
  head "https://gitlab.gnome.org/GNOME/gnome-online-accounts.git", branch: "master"

  livecheck do
    formula "gnome-online-accounts"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "17106a0d2deae6786612b0c40bcee1d22a156179417314cd8a4d249f1f02bbe3"
    sha256 cellar: :any, arm64_sequoia: "a3c65593935f0041c93a4b0682e19f2fd0223bcb008f8396fa7911ba60727c8e"
    sha256 cellar: :any, arm64_sonoma:  "15c94abbbf824c560d7fcf81358d591bea5316312e0ee7ce372d7f751293a6cb"
    sha256 cellar: :any, sonoma:        "dbf3b5e0c2ad4ca481aaf8ca49a0a074fa5441ee670eb7a03c0d77ca26f8ab86"
    sha256               arm64_linux:   "6d40f07d27e14741b7b5e60893278fc3b95f6df93726ecb8074bd351fd8ad05d"
    sha256               x86_64_linux:  "60542266cbd51558098b9417a22d093a3909d143b64da8415f2c9e996e5c25c4"
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

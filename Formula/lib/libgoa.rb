class Libgoa < Formula
  desc "Single sign-on framework for GNOME - client library"
  homepage "https://gitlab.gnome.org/GNOME/gnome-online-accounts"
  url "https://download.gnome.org/sources/gnome-online-accounts/3.54/gnome-online-accounts-3.54.1.tar.xz"
  sha256 "9d058b3aac8b2d8b6b2ae7cb57c8a8abe539e73c88220c315b5b99f87ce6efd8"
  license "LGPL-2.0-or-later"
  head "https://gitlab.gnome.org/GNOME/gnome-online-accounts.git", branch: "master"

  livecheck do
    formula "gnome-online-accounts"
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "88cf0c0155ff178f33ca30a5f61780b29fbb6cc1d66ba5cff0cf5e7294b807fa"
    sha256 cellar: :any, arm64_sonoma:  "8b9ff568fe35b587cd1564609135c29b39f2f9ce5ac548b849643e97cf4e7525"
    sha256 cellar: :any, arm64_ventura: "ec8fede480a5a8a13e77142727f82584d93443f97c1c7ce2228633b6bbd9ff64"
    sha256 cellar: :any, sonoma:        "621833c0bac8d37c39c504b5c592c647965aa5276b78c14f9b6e7459ebb008f2"
    sha256 cellar: :any, ventura:       "5854a0a1b6007e1b4fa5c6cacb185b302601db0037aec3f2fc4233b8769882c7"
    sha256               x86_64_linux:  "8d610279027fb0b6ae82be1b714bb4b38326d18bbc62558d4ae9e47b730d2f07"
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

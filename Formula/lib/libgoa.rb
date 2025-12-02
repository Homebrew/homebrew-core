class Libgoa < Formula
  desc "Single sign-on framework for GNOME - client library"
  homepage "https://gitlab.gnome.org/GNOME/gnome-online-accounts"
  url "https://download.gnome.org/sources/gnome-online-accounts/3.56/gnome-online-accounts-3.56.2.tar.xz"
  sha256 "ce88df65457f0e63a0d8daff13322e29ecb584197a187f48a3a21be2fcd1c824"
  license "LGPL-2.0-or-later"
  head "https://gitlab.gnome.org/GNOME/gnome-online-accounts.git", branch: "master"

  livecheck do
    formula "gnome-online-accounts"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4a90e8349385646ad092554a37a3960c024900251295eb1f418446a0d33bcba8"
    sha256 cellar: :any, arm64_sequoia: "e709b320b7f4a7d105609fd6a45b3822efd5a37a602aa1c3aede9d1eaae948c7"
    sha256 cellar: :any, arm64_sonoma:  "a282bf499ccca1c64bc7deef4828c6a36c06ee932822920a6dce5e223b3005f2"
    sha256 cellar: :any, sonoma:        "3a19e135f8d3dfc59d8e46a49d8be26fede8219b4e9de58eae09da991ac42e49"
    sha256               arm64_linux:   "6f09d38ac646e25b5fa5490f8943218b3d72bd7659d337750ceef080df1512f7"
    sha256               x86_64_linux:  "76e0520792c21f6af8efbaa111d44d932ba32ab92e02bd5f40d3acf182e961b8"
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

class Avahi < Formula
  desc "Service Discovery for Linux using mDNS/DNS-SD"
  homepage "https://avahi.org"
  # NOTE: Temporary exception to use release candidates due to numerous CVEs in 0.8.
  # Same decision made by Arch Linux, Fedora and Gentoo. Debian chose to apply patches.
  # CVE-2021-3468, CVE-2021-3502, CVE-2021-36217, CVE-2021-26720, CVE-2023-1981,
  # CVE-2023-38469, CVE-2023-38470, CVE-2023-38471, CVE-2023-38472, CVE-2023-38473,
  # CVE-2025-59529, CVE-2025-68276, CVE-2025-68468, CVE-2025-68471, CVE-2026-24401
  url "https://github.com/avahi/avahi/archive/refs/tags/v0.9-rc4.tar.gz"
  sha256 "08fcc57377ed05416ec4b3d8a179da716a7a9376821551a5ae16f8276a1ef0b5"
  license "LGPL-2.1-or-later"

  # Remove livecheck after 0.9 release
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+|0\.9-rc\d+)$/i)
  end

  bottle do
    sha256 arm64_linux:  "a86b81c920d871c0f159c3e1008330c29c04170a30da27ed11ce4aac933e43b7"
    sha256 x86_64_linux: "e9136eabe53604d46164d013c689d1d565fd754069a36dd76eab1d8f2e7bd7e3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "m4" => :build
  depends_on "perl" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "xmltoman" => :build

  depends_on "dbus"
  depends_on "expat"
  depends_on "gdbm"
  depends_on "glib"
  depends_on "libcap"
  depends_on "libdaemon"
  depends_on :linux
  depends_on "systemd"

  def install
    system "./bootstrap.sh", "--disable-silent-rules",
                             "--sysconfdir=#{prefix}/etc",
                             "--localstatedir=#{var}",
                             "--disable-mono",
                             "--disable-monodoc",
                             "--disable-python",
                             "--disable-qt4",
                             "--disable-qt5",
                             "--disable-gtk",
                             "--disable-gtk3",
                             "--disable-libevent",
                             "--enable-compat-libdns_sd",
                             "--with-distro=none",
                             "--with-systemdsystemunitdir=no",
                             *std_configure_args
    system "make", "install"

    # mDNSResponder compatibility
    include.install_symlink include/"avahi-compat-libdns_sd/dns_sd.h"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <glib.h>

      #include <avahi-client/client.h>
      #include <avahi-common/error.h>
      #include <avahi-glib/glib-watch.h>
      #include <avahi-glib/glib-malloc.h>

      static void avahi_client_callback (AVAHI_GCC_UNUSED AvahiClient *client, AvahiClientState state, void *userdata)
      {
          GMainLoop *loop = userdata;
          g_message ("Avahi Client State Change: %d", state);

          if (state == AVAHI_CLIENT_FAILURE)
          {
              g_message ("Disconnected from the Avahi Daemon: %s", avahi_strerror(avahi_client_errno(client)));
              g_main_loop_quit (loop);
          }
      }

      int main (AVAHI_GCC_UNUSED int argc, AVAHI_GCC_UNUSED char *argv[])
      {
          GMainLoop *loop = NULL;
          const AvahiPoll *poll_api;
          AvahiGLibPoll *glib_poll;
          AvahiClient *client;
          const char *version;
          int error;

          avahi_set_allocator (avahi_glib_allocator ());
          loop = g_main_loop_new (NULL, FALSE);
          glib_poll = avahi_glib_poll_new (NULL, G_PRIORITY_DEFAULT);
          poll_api = avahi_glib_poll_get (glib_poll);
          client = avahi_client_new (poll_api, 0, avahi_client_callback, loop, &error);

          if (client == NULL)
          {
              g_warning ("Error initializing Avahi: %s", avahi_strerror (error));
          }

          g_main_loop_unref (loop);
          avahi_client_free (client);
          avahi_glib_poll_free (glib_poll);

          return 0;
      }
    C

    pkg_config_flags = shell_output("pkgconf --cflags --libs avahi-client avahi-core avahi-glib").chomp.split
    system ENV.cc, "test.c", "-o", "test", *pkg_config_flags
    assert_match "Avahi", shell_output("./test 2>&1", 134)
  end
end

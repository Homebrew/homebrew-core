class Avahi < Formula
  desc "Service Discovery for Linux using mDNS/DNS-SD"
  homepage "https://avahi.org"
  url "https://github.com/avahi/avahi/archive/refs/tags/v0.8.tar.gz"
  sha256 "c15e750ef7c6df595fb5f2ce10cac0fee2353649600e6919ad08ae8871e4945f"
  license "LGPL-2.1-or-later"
  revision 2

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_linux:  "4167489c0fe787b170d0646faab665700577fcc05ab10e3a0a556112df77d6fc"
    sha256 x86_64_linux: "c2a968c40c0683c2a1cb9e45bbe693434581f0b209e0215f9c610b17069001e8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "m4" => :build
  depends_on "perl" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "xmltoman" => :build

  depends_on "dbus"
  depends_on "expat"
  depends_on "gdbm"
  depends_on "glib"
  depends_on "libdaemon"
  depends_on :linux

  def install
    system "./bootstrap.sh", "--disable-silent-rules",
                             "--sysconfdir=#{prefix}/etc",
                             "--localstatedir=#{prefix}/var",
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
    ln_s include/"avahi-compat-libdns_sd/dns_sd.h", include/"dns_sd.h"
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

    pkg_config_flags = shell_output("pkg-config --cflags --libs avahi-client avahi-core avahi-glib").chomp.split
    system ENV.cc, "test.c", *pkg_config_flags, "-o", "test"
    assert_match "Avahi", shell_output("#{testpath}/test 2>&1", 134)
  end
end

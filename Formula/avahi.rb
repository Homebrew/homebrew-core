class Avahi < Formula
  desc "Service Discovery for Linux using mDNS/DNS-SD"
  homepage "https://avahi.org"
  url "https://github.com/lathiat/avahi/archive/v0.8.tar.gz"
  sha256 "c15e750ef7c6df595fb5f2ce10cac0fee2353649600e6919ad08ae8871e4945f"
  license "LGPL-2.1-or-later"

  bottle do
    rebuild 1
    sha256 x86_64_linux: "bcd10354c4c18f283268b681b80f33262163d4d12ff4ccd55361c19b1b2005cf"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "m4" => :build
  depends_on "perl" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "xmltoman" => :build
  depends_on "dbus"
  depends_on "glib"
  depends_on "libdaemon"
  depends_on :linux

  def install
    system "./bootstrap.sh", "--disable-debug",
                             "--disable-dependency-tracking",
                             "--disable-silent-rules",
                             "--prefix=#{prefix}",
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
                             "--with-distro=none",
                             "--with-systemdsystemunitdir=no"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS

    pkg_config_flags = shell_output("pkg-config --cflags --libs avahi-client avahi-core avahi-glib").chomp.split
    system ENV.cc, "test.c", *pkg_config_flags, "-o", "test"
    assert_match "Avahi", shell_output("#{testpath}/test 2>&1", 134)
  end
end

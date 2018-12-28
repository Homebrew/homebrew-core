class Libnice < Formula
  desc "GLib ICE implementation"
  homepage "https://wiki.freedesktop.org/nice/"
  url "https://nice.freedesktop.org/releases/libnice-0.1.15.tar.gz"
  sha256 "f7280f3f58f594409c719a03009aa819c599078b410796f408251277807587da"

  bottle do
    cellar :any
    sha256 "6eb2104802b309bd2c111eb0a5bc6e287a8e3bb0ef9cff6e1bae0cf0d7195fbd" => :mojave
    sha256 "be32aa20f78d97b09b9fe6e7bfdbad16d1695c2b2c8bd7e2e68d51ddd75659ba" => :high_sierra
    sha256 "2f0e330e16992df3be0db63cf266cd3a1e96a3b54e1ad1511ee3b8ca43cb57f2" => :sierra
    sha256 "5c643f048a70ec3ae6b6ba59ee968023e40a618e99f42983414297bad4ae46ec" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gstreamer"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Based on https://github.com/libnice/libnice/blob/master/examples/simple-example.c
    (testpath/"test.c").write <<~EOS
      #include <agent.h>
      int main(int argc, char *argv[]) {
        NiceAgent *agent;
        GMainLoop *gloop;
        gloop = g_main_loop_new(NULL, FALSE);
        // Create the nice agent
        agent = nice_agent_new(g_main_loop_get_context (gloop),
          NICE_COMPATIBILITY_RFC5245);
        if (agent == NULL)
          g_error("Failed to create agent");

        g_main_loop_unref(gloop);
        g_object_unref(agent);
        return 0;
      }
    EOS

    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/nice
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
      -lnice
    ]
    system ENV.cc, *flags, "test.c", "-o", "test"
    system "./test"
  end
end

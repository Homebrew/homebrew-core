class Libnice < Formula
  desc "GLib ICE implementation"
  homepage "https://wiki.freedesktop.org/nice/"
  url "https://nice.freedesktop.org/releases/libnice-0.1.14.tar.gz"
  sha256 "be120ba95d4490436f0da077ffa8f767bf727b82decf2bf499e39becc027809c"

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
    (testpath/"test.c").write <<-EOS.undent
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

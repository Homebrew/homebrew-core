class Libnice < Formula
  desc "GLib ICE implementation"
  homepage "https://wiki.freedesktop.org/nice/"
  url "https://nice.freedesktop.org/releases/libnice-0.1.17.tar.gz"
  sha256 "1952a0dec58b5c9ccc3f25193df4e2d1244cb382cac611b71e25afcd7b069526"
  # license ["LGPL-2.1", "MPL-1.1"] - pending https://github.com/Homebrew/brew/pull/7953
  license "LGPL-2.1"

  bottle do
    cellar :any
    sha256 "1ebb405afa6b66fddbf4c90ab97f3d9e528f1ce3a11c571bc4d5f10c97a812e6" => :catalina
    sha256 "0d2f05d15e8e188b56758da0c7aaa05109bb85a6c3088e0f9b863d2c10a76961" => :mojave
    sha256 "7851630de0b1da7adf67c514f4d6df037c05ba4e1a426d22029ac8aa20d38877" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gstreamer"

  on_linux do
    depends_on "intltool" => :build
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Based on https://github.com/libnice/libnice/blob/HEAD/examples/simple-example.c
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

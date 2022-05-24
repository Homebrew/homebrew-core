class Libnice < Formula
  desc "GLib ICE implementation"
  homepage "https://wiki.freedesktop.org/nice/"
  url "https://nice.freedesktop.org/releases/libnice-0.1.19.tar.gz"
  sha256 "6747af710998cf708a2e8ceef51cccd181373d94201dd4b8d40797a070ed47cc"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]

  livecheck do
    url "https://github.com/libnice/libnice.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "5bed5cac01c337d9e89b9b40b52cb6c260490bfbcabd7c9e11f6067206958dc2"
    sha256 cellar: :any, arm64_big_sur:  "e444324c67b7c97ec4f44493fd60e02eeffac29fc0c083c666a0f531bd274602"
    sha256 cellar: :any, monterey:       "dd813088a88deeb96ea22eced7583d870fa1e116f79c2987c1a7040eaa46a78d"
    sha256 cellar: :any, big_sur:        "f29c7cad45b224ae2d071cb42fe1cbcd9e0207642d965088a4030057e3244af3"
    sha256 cellar: :any, catalina:       "a3dd3ec0a451c3cfa51d405930234c470cbab8854e3dafcbb9e24588a0869bcd"
    sha256               x86_64_linux:   "39864bd802e7e78eee47b607ff85e22eacf97636187f79e6f857901e64eef25b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gstreamer"

  on_linux do
    depends_on "intltool" => :build
  end

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
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
      -lnice
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

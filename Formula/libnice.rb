class Libnice < Formula
  desc "GLib ICE implementation"
  homepage "https://wiki.freedesktop.org/nice/"
  url "https://nice.freedesktop.org/releases/libnice-0.1.18.tar.gz"
  sha256 "5eabd25ba2b54e817699832826269241abaa1cf78f9b240d1435f936569273f4"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]

  livecheck do
    url "https://github.com/libnice/libnice.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_monterey: "5581f07b30fd73e609004ff104bbf029c185c19fd28d4e54f9e96dbf9d40fb0a"
    sha256 cellar: :any, arm64_big_sur:  "0c414fc1c0583fc19cbb8e604914315a4118da705ad5cd78a6472410cd8c0b5b"
    sha256 cellar: :any, monterey:       "a6f64b14516006f7b81dc1e74d5fe08b06e718e49b00133999b0ee054012f865"
    sha256 cellar: :any, big_sur:        "af306d90fda80e3afe83851672ec34a679e55595431383b5ba246051fc827895"
    sha256 cellar: :any, catalina:       "eafa60c41c7d017627859714e5a1028151376432e1c5802b95f65f81a191016d"
    sha256 cellar: :any, mojave:         "657ffb5240531a8dc9e918c2aec1c74fca62af994524e002d674ce9fbe52e4c1"
    sha256               x86_64_linux:   "5a9f6bdf5b31637f23cfa5bc3762a9931e46f35bef1da914f99d0c0555003b33"
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
    on_macos do
      flags << "-lintl"
    end
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

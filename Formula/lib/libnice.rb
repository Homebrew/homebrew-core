class Libnice < Formula
  desc "GLib ICE implementation"
  homepage "https://wiki.freedesktop.org/nice/"
  url "https://libnice.freedesktop.org/releases/libnice-0.1.21.tar.gz"
  sha256 "72e73a2acf20f59093e21d5601606e405873503eb35f346fa621de23e99b3b39"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]

  livecheck do
    url "https://github.com/libnice/libnice.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "d03740d14e2009f6020c2aa22f0c54e91ab541e9ddce13b170b7e6a653a233f3"
    sha256 cellar: :any, arm64_monterey: "43a9ca6f5f47660e216a8944e0632cfa2bb37d8a6d7ef0c6172be7ee21a67c14"
    sha256 cellar: :any, arm64_big_sur:  "89ac0d78a723256971b3a55a94cf1df6837efb7984bce54e27a38b7ef6e5a1a7"
    sha256 cellar: :any, ventura:        "dbb917600a8a1ca8e182bda8e04e257d33516aab50560200f3919daf451dd5fd"
    sha256 cellar: :any, monterey:       "131822c8212f7e84014a6cfc395d0714fd34c57508cc6c8f8759cf42f9f25db9"
    sha256 cellar: :any, big_sur:        "b14dc9baa15c60604d3927bb71116b8dd61c0d8490a710a6b9a986d4948dc55b"
    sha256               x86_64_linux:   "a1276510091d4feb7ab30df7dd2da106be0d61b26c2f441eec3d7e623b83d51d"
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

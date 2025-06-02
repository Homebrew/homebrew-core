class Libnice < Formula
  desc "GLib ICE implementation"
  homepage "https://wiki.freedesktop.org/nice/"
  url "https://libnice.freedesktop.org/releases/libnice-0.1.22.tar.gz"
  sha256 "a5f724cf09eae50c41a7517141d89da4a61ec9eaca32da4a0073faed5417ad7e"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]

  livecheck do
    url "https://github.com/libnice/libnice.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "e1f4f8532d745a6555e861c342f56ec7a0d0b827f13b4e80c4d6218857b3ae2f"
    sha256 cellar: :any, arm64_sonoma:  "9582197a0a9f71c2e6751c739c24027e55294303a1ca878091a751513898417d"
    sha256 cellar: :any, arm64_ventura: "14745e9ade6980ce27101f8be9ea209180aabd691628f908acac939e8249a3e2"
    sha256 cellar: :any, sonoma:        "bfa1f6813b1bc1fe0be25937d85b2eeff7288b8f93b1c5e70c3a1e72562febfb"
    sha256 cellar: :any, ventura:       "e50b4f94bf2ec4bf8248bf41a32ea1af1fdc512037b1d6d7919cbbf14048d00b"
    sha256               arm64_linux:   "b7ea837e5b54eaf09849dd773a4af189817ec6ffda519323f300899151f05a77"
    sha256               x86_64_linux:  "6805ee9bd44ec5f3573d1fc688d2beac5971904de5996c1239d406de74a37965"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "glib"
  depends_on "gnutls"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "intltool" => :build
  end

  def install
    system "meson", "setup", "build", "-Dgstreamer=disabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # Based on https://github.com/libnice/libnice/blob/HEAD/examples/simple-example.c
    (testpath/"test.c").write <<~C
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
    C

    flags = shell_output("pkgconf --cflags --libs nice").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

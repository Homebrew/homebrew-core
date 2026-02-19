class Libnice < Formula
  desc "GLib ICE implementation"
  homepage "https://wiki.freedesktop.org/nice/"
  url "https://libnice.freedesktop.org/releases/libnice-0.1.23.tar.gz"
  sha256 "618fc4e8de393b719b1641c1d8eec01826d4d39d15ade92679d221c7f5e4e70d"
  license any_of: ["LGPL-2.1-only", "MPL-1.1"]
  head "https://github.com/libnice/libnice.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "aff56c13ea1c1b8a67106c35abd4b1e8cfb0c25a050b19a709e9b7dda05a21a6"
    sha256 cellar: :any, arm64_sequoia: "2ce7f4b3513f8f0bc5a574657291093a61958176efa4347c096ddbfb6adae60f"
    sha256 cellar: :any, arm64_sonoma:  "eb5403dd6e4c63f698edc26dbf454915f3b71c5a9e66e214c91aa3511dd28936"
    sha256 cellar: :any, sonoma:        "125053ae9a07a8ab04b8bc523c97249ccd92e4ff2f48b244bb0d7a42ecd4d694"
    sha256               arm64_linux:   "3c95ab94575eafa055c04796fc29518f6d57bc7f2db24a672c7a6a449698641b"
    sha256               x86_64_linux:  "fa1c1187e54ab5e09063d9cb5e92575c30e8f7d8826d8c2c2ecf96357cd6ca7c"
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

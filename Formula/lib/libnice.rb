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
    sha256 cellar: :any, arm64_sonoma:   "561998831e0aa0fd61bd6ba913249959b5990a527f3b201151acebb9ba36e166"
    sha256 cellar: :any, arm64_ventura:  "864676854f73e9d95de61dfd004f4e49e161fcca41a58b2aab7e6d2f03e1715d"
    sha256 cellar: :any, arm64_monterey: "c0b2d5e710b9748cb14804ccfc32b8f08949f4212313c0c3eed8b74fb0b2e3a9"
    sha256 cellar: :any, sonoma:         "e05d0d12b548e049380c972439f152ebc10a58312eb1a2d3666df570e174a6b7"
    sha256 cellar: :any, ventura:        "9848b98bcee8122cc9d4867332d4dc372faba88cfecf4a58e54ef6cbdb803f76"
    sha256 cellar: :any, monterey:       "73566f6bbd1496154268a114ef5bc53f1b03330fd8f7b62a15d87de7dde35793"
    sha256               x86_64_linux:   "392d7eb8bea2d013695a4d57d7a5849d702d018f9d1e2009accd01edbc979784"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]

  depends_on "glib"
  depends_on "gnutls"
  depends_on "gstreamer"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "intltool" => :build
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
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

    pkg_config_cflags = shell_output("pkg-config --cflags --libs nice").chomp.split
    system ENV.cc, "test.c", *pkg_config_cflags, "-o", "test"
    system "./test"
  end
end

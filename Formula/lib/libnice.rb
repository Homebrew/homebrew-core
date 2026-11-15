class Libnice < Formula
  desc "GLib ICE implementation"
  homepage "https://wiki.freedesktop.org/nice/"
  url "https://libnice.freedesktop.org/releases/libnice-0.1.24.tar.gz"
  sha256 "cfb5e8e778534f2f5b3c6f4958a1eb057c6b95c537c0f100817a537cf5d64fcc"
  license any_of: ["LGPL-2.1-or-later", "MPL-1.1"]
  compatibility_version 1
  head "https://gitlab.freedesktop.org/libnice/libnice.git", branch: "master"

  livecheck do
    url "https://libnice.freedesktop.org/"
    regex(/href=.*?libnice[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "16d679567bd1dee436e90c55e17b29cd0b945da26f8946f8a0d9a2f55237ddfd"
    sha256 cellar: :any, arm64_tahoe:       "e6ea7526c0b8a0b26fdcc03455328d79f7455a84a5187ae4ba4f7e689e5a7bd9"
    sha256 cellar: :any, arm64_sequoia:     "6d4020030f85a308f0597286c1393e36a0db1496e58e422bf4388905de82a811"
    sha256 cellar: :any, arm64_sonoma:      "e9daffb2c2b76d908a3ce3c7e59192ab86d59cba9fa34a7135216cc05060fbd6"
    sha256 cellar: :any, arm64_linux:       "7fe65c9279876a022d542a3f8f2454e9453904e226e767dcb70db7dd7a348a52"
    sha256 cellar: :any, x86_64_linux:      "21aa22274a49bb3275c2a14e9ba63793e84263b604016b6374c3cd2ec6bd780b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "glib"
  depends_on "gnutls"

  on_macos do
    depends_on "gettext"
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

class Gssdp < Formula
  desc "GUPnP library for resource discovery and announcement over SSDP"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gssdp/1.6/gssdp-1.6.6.tar.xz"
  sha256 "767d2275254ce0efeaeac64419ff9f4f0ad470d134ef672f5c556b2abb786bcb"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4e0ed096a873cd3c8ccc2407bad5c975aa3b6cbb3e54e309f3457dc779efc926"
    sha256 cellar: :any, arm64_sequoia: "f23aacffe48fc74672e44f272db8f929911725b0cd6d54b5069b665847825dc3"
    sha256 cellar: :any, arm64_sonoma:  "f151fbe7b2f92e07dc7768691dddbe2cb5a84cbf6613f7394c571dddbb8ded23"
    sha256 cellar: :any, sonoma:        "3ae47d87ad29f55685a8eb12eccbf29ef39c9f44b4f5d857875b2befd6bc92c0"
    sha256               arm64_linux:   "d8f578ef049a3a68fe2a094d8cd6847903a1cd7611ad59534d908ce04374265e"
    sha256               x86_64_linux:  "a219300565d729549e5774cc58eda097008db267c981d647fc6fbc461a0d73be"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pandoc" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "libsoup"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV.prepend_path "XDG_DATA_DIRS", HOMEBREW_PREFIX/"share"

    system "meson", "setup", "build", "-Dsniffer=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libgssdp/gssdp.h>

      int main(int argc, char *argv[]) {
        GType type = gssdp_client_get_type();
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs gssdp-1.6").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

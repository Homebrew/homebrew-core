class Gssdp < Formula
  desc "GUPnP library for resource discovery and announcement over SSDP"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gssdp/1.6/gssdp-1.6.5.tar.xz"
  sha256 "34fd824c36ef9f575594d5572728412ddb8c522f606b6c913ef8b5a800aafc4e"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "11eeb536299fe7b73abef10de18c75828b8e600c6b8e75dea28fb353e99c8c3c"
    sha256 cellar: :any, arm64_sequoia: "02fa2e830c238c8de15acda86ae0fcca5b1894955ec691de32a1a02dd05d76df"
    sha256 cellar: :any, arm64_sonoma:  "f7abf203a981a9c60f74687194c46682655f4106ce4270592b5b91d3bff46b99"
    sha256 cellar: :any, sonoma:        "d05c95feba8ff9a61786d491a8511b326047c7b1d576a241ba4d11b8fea9db54"
    sha256               arm64_linux:   "79fdb44abfd486bb395554650aabae71ab754f4b1a4c072f0715162c41f886af"
    sha256               x86_64_linux:  "e878abe338a5c0b9e3dcc340ccc86e9781f6060f7db09aae12c07b1c1467a519"
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

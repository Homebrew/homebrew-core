class Gssdp < Formula
  desc "GUPnP library for resource discovery and announcement over SSDP"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gssdp/1.6/gssdp-1.6.0.tar.xz"
  sha256 "148ed41628c8f17336a2c8fa4b14ab0fbae98b6026be2dacfddea7bf43866689"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_monterey: "6d1d2fd00d1e4063bd3ae084c920c5903b4b476bddc259c3cdac42ccc24d3ed4"
    sha256 cellar: :any, arm64_big_sur:  "9f8e5df0f0ff86f39f3d14d96952731b5e56519e133dbb23098b3be86ee325e2"
    sha256 cellar: :any, monterey:       "0488549919c434068ff0ddc900c5ef4e8fdfb1b58555ab0bc8764f585771e5ae"
    sha256 cellar: :any, big_sur:        "29b4fdb41b3229d620e602a503046e6cf58a7f08fb2f83be4df94fbb8f5ccaac"
    sha256 cellar: :any, catalina:       "f8478c7402cafddb596fbffd2c0f71e425ddda0d06a748064bf003601ead2f47"
    sha256               x86_64_linux:   "8cf14f9b99a3db106729013d2f557fb18792f2947a8b7cba5edf72fd77f3d9f9"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "libsoup"

  def install
    ENV.prepend_path "XDG_DATA_DIRS", HOMEBREW_PREFIX/"share"
    ENV.prepend_path "XDG_DATA_DIRS", Formula["libsoup"].opt_share

    system "meson", "setup", "build", "-Dsniffer=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libgssdp/gssdp.h>

      int main(int argc, char *argv[]) {
        GType type = gssdp_client_get_type();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/gssdp-1.2
      -D_REENTRANT
      -L#{lib}
      -lgssdp-1.2
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end

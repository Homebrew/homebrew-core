class Gssdp < Formula
  desc "GUPnP library for resource discovery and announcement over SSDP"
  homepage "https://wiki.gnome.org/GUPnP/"
  url "https://download.gnome.org/sources/gssdp/1.4/gssdp-1.4.0.1.tar.xz"
  sha256 "8676849d57fb822b8728856dbadebf3867f89ee47a0ec47a20045d011f431582"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_ventura:  "7dbdc99df01f118aee8140781d94d0d96e686d950a646944f6e99811ccc67da5"
    sha256 cellar: :any, arm64_monterey: "6d1d2fd00d1e4063bd3ae084c920c5903b4b476bddc259c3cdac42ccc24d3ed4"
    sha256 cellar: :any, arm64_big_sur:  "9f8e5df0f0ff86f39f3d14d96952731b5e56519e133dbb23098b3be86ee325e2"
    sha256 cellar: :any, ventura:        "ba20bede2cdfdf92c43c7134a934089b0b7b2ac94ae6154d1906eaa2dfc98dff"
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
  depends_on "libsoup@2"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libsoup@2"].opt_lib/"pkgconfig"
    ENV.prepend_path "XDG_DATA_DIRS", Formula["libsoup@2"].opt_share
    ENV.prepend_path "XDG_DATA_DIRS", HOMEBREW_PREFIX/"share"

    mkdir "build" do
      system "meson", *std_meson_args, "-Dsniffer=false", ".."
      system "ninja"
      system "ninja", "install"
    end
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

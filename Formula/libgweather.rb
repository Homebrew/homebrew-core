class Libgweather < Formula
  desc "GNOME library for weather, locations and timezones"
  homepage "https://wiki.gnome.org/Projects/LibGWeather"
  url "https://download.gnome.org/sources/libgweather/4.2/libgweather-4.2.0.tar.xz"
  sha256 "af8a812da0d8976a000e1d62572c256086a817323fbf35b066dbfdd8d2ca6203"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  version_scheme 1

  # Ignore version 40 which is older than 4.0 as discussed in
  # https://gitlab.gnome.org/GNOME/libgweather/-/merge_requests/120#note_1286867
  livecheck do
    url :stable
    strategy :gnome do |page, regex|
      page.scan(regex).select { |match| Version.new(match.first) < 40 }.flatten
    end
  end

  bottle do
    sha256 arm64_monterey: "2cfc7ff943b1d00488fb70125e837ad77e9f71bea804e3e7a03dbc5db0e24883"
    sha256 arm64_big_sur:  "748389d72bb3f3c118fa84647fbd00f5180d716a08a3f4588c215a54c9a9992d"
    sha256 monterey:       "5963be2b91c72fd4fd9240c1e644e237d48333df89db5985144ceae8a9849944"
    sha256 big_sur:        "1e027c5251e2d55c3a2f054907efe1f7e8f660c358d2e98a530011e6be6a6e65"
    sha256 catalina:       "6e2e7b5acd9e182a19a3696ce631ee67b477d30c359e2163284bc4c1f135ec4e"
    sha256 x86_64_linux:   "b22f6f49cedb71e8789bee404274b7407f16d8e6717dd8fc7981ced3bd80b0b4"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "pygobject3" => :build
  depends_on "python@3.10" => :build
  depends_on "geocode-glib"
  depends_on "gtk+3"
  depends_on "libsoup"

  uses_from_macos "libxml2"

  def install
    ENV["DESTDIR"] = "/"
    system "meson", *std_meson_args, "build", "-Dgtk_doc=false", "-Dtests=false"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libgweather/gweather.h>

      int main(int argc, char *argv[]) {
        GType type = gweather_info_get_type();
        return 0;
      }
    EOS
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["icu4c"].opt_lib/"pkgconfig" if OS.mac?
    pkg_config_flags = shell_output("pkg-config --cflags --libs gweather4").chomp.split
    system ENV.cc, "-DGWEATHER_I_KNOW_THIS_IS_UNSTABLE=1", "test.c", "-o", "test", *pkg_config_flags
    system "./test"
  end
end

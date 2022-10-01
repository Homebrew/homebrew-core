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
    rebuild 1
    sha256 arm64_big_sur: "b13c7715d841a75ea106450bf14df81648725829b8142a4723ee155901ab8998"
    sha256 monterey:      "281f8f7f0e9e5ef0c44239f0f404888a61934c8051000293b9ad5a61d92dc4e7"
    sha256 big_sur:       "c8b80b40fde5432a83885430d0791147ec594e1849420416b47eaa521e679044"
    sha256 catalina:      "7eb0152cd6f73075a4516f4bf4125417d61a0197cb46d764789d365d9fb4f284"
    sha256 x86_64_linux:  "22842026d482f9e95bcd2131104c2dce4937eab9d3f48b3319a0f208b6e4e329"
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

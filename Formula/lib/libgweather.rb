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
    sha256 arm64_ventura:  "10e3aa3f43d4613c79ede732e46bc59afb9795881388600a93dff38ff2983c1a"
    sha256 arm64_monterey: "dd362d2581760d1ad24032bef6602950afbb95d2a03d8227d99dc457f8e18aa0"
    sha256 arm64_big_sur:  "e290a296815fc815693df0c9d5f1535603e05ba359b9de0e449381d5c8ee9967"
    sha256 ventura:        "1251d458064a2d2ed5275781e3fe5a03bf87fd408e29eb483eefc7bbb1831aa9"
    sha256 monterey:       "09f7e049f0ba4abc43dd43ce8c24722b18e0d9d77897795663e3ddf865cbb4ab"
    sha256 big_sur:        "e3c037ec03dedafb98a73a7ace0028f3a390d39f840e74cd73ec6e7d553fdacb"
    sha256 x86_64_linux:   "e01185848d3a1fbaed6bdb58b7921c4e13076649a23a8577e8687852ae5a63f1"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "pygobject3" => :build
  depends_on "python@3.11" => :build
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

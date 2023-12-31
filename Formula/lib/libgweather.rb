class Libgweather < Formula
  desc "GNOME library for weather, locations and timezones"
  homepage "https://wiki.gnome.org/Projects/LibGWeather"
  url "https://download.gnome.org/sources/libgweather/4.4/libgweather-4.4.0.tar.xz"
  sha256 "366e866ff2a708b894cfea9475b8e8ff54cb3e2b477ea72a8ade0dabee5f48a4"
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
    sha256 arm64_sonoma:   "14452e8ad34e53e9f3c3f1e9814028748e257d324d174805404046ed0b7d57af"
    sha256 arm64_ventura:  "477b304b8271e17885e266f41bded0968aada1d586374bec31917e2d781f096e"
    sha256 arm64_monterey: "77f609d6a257549a96e7897ea6e2b9bb69c6470e37d8982face334b73d87498c"
    sha256 sonoma:         "0f410cf62efd6c02c41af55e4639e88aac047f7e39142a4153051686895d2ff5"
    sha256 ventura:        "ffc9e20982fc997d3c4b821cf443acb62483582cb2da9386cdc64eeed2e8db2d"
    sha256 monterey:       "974bbac2ebb66b77d8b987eaed48e6df65a10f83e111d46b106566d820cb2682"
    sha256 x86_64_linux:   "f95c30bbe9752c9cf0b3b0caa3a01f10d7f22d45c9e9682f470a294fc5710058"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "pygobject3" => :build
  depends_on "python@3.12" => :build
  depends_on "geocode-glib"
  depends_on "gtk+3"
  depends_on "libsoup"

  uses_from_macos "libxml2"

  def install
    ENV["DESTDIR"] = "/"

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "meson", "setup", "build", "-Dgtk_doc=false", "-Dtests=false", *std_meson_args
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

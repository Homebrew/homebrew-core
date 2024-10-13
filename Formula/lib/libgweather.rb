class Libgweather < Formula
  desc "GNOME library for weather, locations and timezones"
  homepage "https://wiki.gnome.org/Projects/LibGWeather"
  url "https://download.gnome.org/sources/libgweather/4.4/libgweather-4.4.4.tar.xz"
  sha256 "7017677753cdf7d1fdc355e4bfcdb1eba8369793a8df24d241427a939cbf4283"
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
    sha256 arm64_sequoia:  "c7697434e255dd1ceb91bed8baa441dce6be4c8f6eab61906f42a9aea4f57426"
    sha256 arm64_sonoma:   "02c91201c18a93a45588abf946d3b636890dc31761978d0630d8ab7446aa0dc3"
    sha256 arm64_ventura:  "d2d0765dc966fa1299d58c4c279380f0da767d6ce0d47a8ae32200afeb1ccdc9"
    sha256 arm64_monterey: "afee30653b964979c9f1e10d068faa99de4fcec840ae6ae62a6561b12eb6baf3"
    sha256 sonoma:         "1b10edad1de33da77f30b0253d12f8b1f094fa3bcebeb2d507f8dfc668a96b68"
    sha256 ventura:        "66e04fe281db63f8c3f31efe8af83c04364a94d38622a39ea814a4add7fc9947"
    sha256 monterey:       "1b16600b10b73bac96dcf7bcf174318d4c80e80d34388a672f28a247b780f9e7"
    sha256 x86_64_linux:   "8836ddf538d68d22693e2f916410c6872d9a22ae51ddf1176436580eecf5e192"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "pygobject3" => :build
  depends_on "python@3.12" => :build

  depends_on "geocode-glib"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "json-glib"
  depends_on "libsoup"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

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

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
    rebuild 1
    sha256 arm64_sequoia: "def0a9ed0b83c1c6601df15db175bb336f73fd853f86c93a1a0cc1994ea467bf"
    sha256 arm64_sonoma:  "4bdf722d36c2c99c6a3dd7d816cfd3d73e439a9225ed36e0bee4240193f5f4d8"
    sha256 arm64_ventura: "bb2d31e83d13f02446f7e5b523eeeb4cdf86e2065a8572ff1cd449b9abf1ea7c"
    sha256 sonoma:        "186ce1fa070215a5d1bd8a1f7d8ab3e64113dfb069a315a82c30853d230fecdf"
    sha256 ventura:       "255051452c7188eeec6d22267edae06a83e797a0713ab80d805ec52968cf7d65"
    sha256 arm64_linux:   "095621c2603b0088caea217355becba74fb1ece6bd06c1a4f21a0b23496711a1"
    sha256 x86_64_linux:  "e2107ed28850147098f165b516687d2e7a0aa494d39fbb4ac1326ebdb74c4ecc"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "pygobject3" => :build
  depends_on "python@3.13" => :build

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
    (testpath/"test.c").write <<~C
      #include <libgweather/gweather.h>

      int main(int argc, char *argv[]) {
        GType type = gweather_info_get_type();
        return 0;
      }
    C
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["icu4c"].opt_lib/"pkgconfig" if OS.mac?
    flags = shell_output("pkgconf --cflags --libs gweather4").chomp.split
    system ENV.cc, "-DGWEATHER_I_KNOW_THIS_IS_UNSTABLE=1", "test.c", "-o", "test", *flags
    system "./test"
  end
end

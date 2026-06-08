class Libgweather < Formula
  desc "GNOME library for weather, locations and timezones"
  homepage "https://wiki.gnome.org/Projects/LibGWeather"
  url "https://download.gnome.org/sources/libgweather/4.6/libgweather-4.6.0.tar.xz"
  sha256 "7f5d0e8c9685ef2ff46c2f3a57cae48d7bf3540b2d83921f889ef28e6a876788"
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
    sha256 arm64_tahoe:   "9fd00f76cad9cad7c3458915abfd3c74822a820d0f742bd06136590ec3eb6f37"
    sha256 arm64_sequoia: "d782557928860afcaede44976c28aaa2cbd1395cd309a1b9d277f7e1477f8991"
    sha256 arm64_sonoma:  "35aa98175b736e757aae5d496c4ab55c987fb59fe318e35b9717b2d2fe26ca77"
    sha256 sonoma:        "39143bc46d845f310f70ec476c76282f8f242cf41aa7625fc4ba8d043e89fbc8"
    sha256 arm64_linux:   "d519c7073bef541b39bc8c07db8e5880621b7beb770859f5a68ba4d9a6ac9e33"
    sha256 x86_64_linux:  "4c4db1d9ff76e7ec17e4c8d5b6694da60ee7d4634aecf1e175036e5f76585f4e"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "pygobject3" => :build
  depends_on "python@3.14" => :build

  depends_on "geocode-glib"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "json-glib"
  depends_on "libsoup"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  resource "gweather-locations" do
    url "https://gitlab.gnome.org/GNOME/gweather-locations/-/archive/2026.2/gweather-locations-2026.2.tar.bz2"
    sha256 "6fac60bd832782bf65f8e2d47e9a33de79a1c5bae9dacdd0e414bf465b3b52a2"
  end

  def install
    resource("gweather-locations").stage do
      system "meson", "setup", "build", *std_meson_args
      system "meson", "compile", "-C", "build", "--verbose"
      system "meson", "install", "-C", "build"
    end
    ENV.prepend_path "PKG_CONFIG_PATH", share/"pkgconfig"
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", "-Dgtk_doc=false", "-Dtests=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  post_install_steps do
    compile_gsettings_schemas
  end

  test do
    assert_path_exists lib/"gweather-locations/Locations.bin"

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

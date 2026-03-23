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
    sha256 arm64_tahoe:   "ac0399364b4299b04ae70b9be4364d5e7ccd08e23f5cc841adceea96cbea463a"
    sha256 arm64_sequoia: "0d6fd8e92f625d3e6baa9ef99627e19b4504ccbb4ad5f5d887d21d6a24772146"
    sha256 arm64_sonoma:  "d968d586e39ceb5a9ca8e7c1ecd047ac36c7abdd06ec415739f053786f502bc7"
    sha256 sonoma:        "df230a6fe7d85a3860238afa322703f616e1d7b5d873c20a7ad32c5927315f6e"
    sha256 arm64_linux:   "6ae4d2326fbcf68ad6b4902dc7315ad87a551a1c4ac0fc2de9487eb40b63cff6"
    sha256 x86_64_linux:  "b6b4dcb96c53ab71fb3c243a7ed9e804c074a86061cb6e277f4e0228e656cef6"
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

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
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

class Libgweather < Formula
  desc "GNOME library for weather, locations and timezones"
  homepage "https://wiki.gnome.org/Projects/LibGWeather"
  url "https://download.gnome.org/sources/libgweather/4.4/libgweather-4.4.4.tar.xz"
  sha256 "7017677753cdf7d1fdc355e4bfcdb1eba8369793a8df24d241427a939cbf4283"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 1
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
    sha256 arm64_tahoe:   "a0f5b2a53daf3be868d2601e99ae2119a51457676016d1f15bb0932d6a413449"
    sha256 arm64_sequoia: "819f5d39b980380a41bab9e47e4345043691db9cde55caf74728800d968a68cb"
    sha256 arm64_sonoma:  "457c6988412179b63a5d92df5281106dc4b09a4770448f66f855e3ab004e5675"
    sha256 sonoma:        "772860847b0744d9ee83a44cf92ff70894473bf87ddde2c14d37e5422b873a2f"
    sha256 arm64_linux:   "7932cb5f77bcc83782f3816e631dd48d05198affdc9e1e6a3cdab639dc147394"
    sha256 x86_64_linux:  "cf5d68a71f9c30705d01484985fe117809f4f5ad93f853638c6ca670b32314a1"
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

  # Backport fix for "error: call to undeclared library function 'alloca'"
  patch do
    url "https://gitlab.gnome.org/GNOME/libgweather/-/commit/12080775978b6d5140c741562894ea5d21601e15.diff"
    sha256 "64f638c4ffe0936016117f7355a1bbbbf2fec41b1e67bb64eac1bdca760eba23"
  end

  def install
    ENV["DESTDIR"] = "/"

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

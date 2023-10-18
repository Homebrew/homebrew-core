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
    sha256 arm64_sonoma:   "ee3a782ad0080556efed2dd19cbffc48fa32947a827a5ccef4ff9177081926fa"
    sha256 arm64_ventura:  "c9e1eeada0b4081e82c1d7d1929a5c54e78aa649234667ecc5c76b16a221d081"
    sha256 arm64_monterey: "a52f7ea41f7a0203e6bcb24898c3bf77342cc6ab75110bf78c0f4b7b4b02b80b"
    sha256 arm64_big_sur:  "ac0adc0208bd10f79f7e6485b1ba1de9b79d934b8351d87c421ce375a421f48b"
    sha256 sonoma:         "c2523d7fc1ebbdcf8aff02472f7b0c0d481367be96e400b1dd2b1b1c50beb42a"
    sha256 ventura:        "1b9db7cb123b8277d1547770c80b853b449921fdbb43770bab8a54ba9a1e7099"
    sha256 monterey:       "662c16a569a2d12e42116cd0c4e6ae517f2ed6d20df293c7ec2a1d3d37cbf426"
    sha256 big_sur:        "7352814c38a221c5970b5beb2e673707573985bc4184731a3f46700a55d91833"
    sha256 x86_64_linux:   "a6ffa551f6f61451b13c708ac3e30eb3233bdeee6c4735927cf2689920a3e114"
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

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

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

class Libgweather < Formula
  desc "GNOME library for weather, locations and timezones"
  homepage "https://wiki.gnome.org/Projects/LibGWeather"
  url "https://download.gnome.org/sources/libgweather/4.4/libgweather-4.4.2.tar.xz"
  sha256 "a6e427b4770ada48945f3aa906af710fc833cff0d42df91f1828302740d794ec"
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
    sha256 arm64_sonoma:   "e0ef8f8736b53583da15408c467a9dfb8feb135c4c904838bf64d3aa5d0202cd"
    sha256 arm64_ventura:  "6c52028e226233657fc77cbd8a887e368b261d1b50ccdfc68173573e6e06cff2"
    sha256 arm64_monterey: "7a4e4e256b900deb768298bc9b2e41cf454f1f712a9fe86d308979add8cf93d0"
    sha256 sonoma:         "d4cad5470dd1b33ad275bac768106918947e666e41c6cb07aa923ce26655a4aa"
    sha256 ventura:        "6df289e4c7b64757696490a044e23003b26884e744709830c4016e10d1760a92"
    sha256 monterey:       "c2c8b1a04db977e88bcf56384a715be5b48af5175339c23644cd47508203aae1"
    sha256 x86_64_linux:   "5489a2ac860e4a8bbeb4545939d78eaa5b975a6cd6bd7e619f0ddb15a357f00b"
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

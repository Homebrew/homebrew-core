class Gtk4 < Formula
  desc "Toolkit for creating graphical user interfaces"
  homepage "https://gtk.org/"
  url "https://download.gnome.org/sources/gtk/4.24/gtk-4.24.2.tar.xz"
  sha256 "05561abc25d1b1400136bf79ab68830cb4b053d1922ae97e551b3f19755bf3cb"
  license "LGPL-2.1-or-later"
  compatibility_version 1
  head "https://gitlab.gnome.org/GNOME/gtk.git", branch: "main"

  livecheck do
    url :stable
    regex(/gtk[._-](4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    manifest_sha256 "8afb4468e76f5686b64edb7271b909ae70233fc71c69f1c0c4371bf4490609bd"
    sha256 arm64_golden_gate: "ac84f292cfe34edaea2c71f6fe1d5db8a35d8c977c4d2d739d3a7ddc31a95cc9"
    sha256 arm64_tahoe:       "23bd4f24e87cb8570d7eebace333c63d15657edb9daa19f62bdd3470dc9628bf"
    sha256 arm64_sequoia:     "7fabebf916e8e6c2db85ab180c048f816c0f1d88c225c3212081f4b8a7f1b769"
    sha256 arm64_linux:       "b11b3c0c20bb5ef2006a7d57d505b11b1886f8b0d7b8b5bca487afa356f37a82"
    sha256 x86_64_linux:      "2a566109e30a675e7d56c339f7dbf37b075a2503368a729b011a335029fbb0cc"
  end

  depends_on "dart-sass" => :build
  depends_on "docbook" => :build
  depends_on "docbook-xsl" => :build
  depends_on "docutils" => :build
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "fribidi"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "graphene"
  depends_on "harfbuzz"
  depends_on "hicolor-icon-theme"
  depends_on "jpeg-turbo"
  depends_on "libepoxy"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libtiff"
  depends_on "pango"

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "cups"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "wayland-protocols" => :build
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "libxdamage"
    depends_on "libxext"
    depends_on "libxfixes"
    depends_on "libxi"
    depends_on "libxinerama"
    depends_on "libxkbcommon"
    depends_on "libxrandr"
    depends_on "wayland"
  end

  deny_network_access!

  def install
    # Replace deprecated `sassc` with `sass` in the meson build file
    inreplace "gtk/meson.build" do |s|
      s.gsub! "'sassc'", "'sass'"
      s.gsub! "'-a', '-M', '-t', 'compact'", "'--style', 'compressed'"
    end
    inreplace "build-aux/meson/dist-data.py", "'-a', '-M', '-t', 'compact'", "'--style', 'compressed'"

    args = %w[
      -Dbuild-examples=false
      -Dbuild-tests=false
      -Dintrospection=enabled
      -Dman-pages=true
      -Dmedia-gstreamer=disabled
      -Dvulkan=disabled
    ]

    if OS.mac?
      args << "-Dx11-backend=false"
      args << "-Dmacos-backend=true"
    end

    # ensure that we don't run the meson post install script
    ENV["DESTDIR"] = "/"

    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    # Disable asserts and cast checks explicitly
    ENV.append "CPPFLAGS", "-DG_DISABLE_ASSERT -DG_DISABLE_CAST_CHECKS"

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  post_install_steps do
    compile_gsettings_schemas
    update_gtk_icon_cache
  end

  test do
    (testpath/"test.c").write <<~C
      #include <gtk/gtk.h>

      int main(int argc, char *argv[]) {
        gtk_disable_setlocale();
        return 0;
      }
    C

    flags = shell_output("#{formula_opt_bin("pkgconf")}/pkgconf --cflags --libs gtk4").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
    # include a version check for the pkg-config files
    assert_match version.to_s, shell_output("cat #{lib}/pkgconfig/gtk4.pc").strip
  end
end

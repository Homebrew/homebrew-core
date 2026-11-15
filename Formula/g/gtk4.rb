class Gtk4 < Formula
  desc "Toolkit for creating graphical user interfaces"
  homepage "https://gtk.org/"
  url "https://download.gnome.org/sources/gtk/4.24/gtk-4.24.1.tar.xz"
  sha256 "e98abe720e16129c8c0f50761dee0a2e9ae2478055e31018f6cf977fcf6513e9"
  license "LGPL-2.1-or-later"
  compatibility_version 1
  head "https://gitlab.gnome.org/GNOME/gtk.git", branch: "main"

  livecheck do
    url :stable
    regex(/gtk[._-](4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "70c0736217175c13b2b2464a71dab2012716d9526c3f0a11a4eab1c858441e73"
    sha256 arm64_tahoe:       "654059a8dcf646b074ff00b890993e0913e9deee1214d08a2e9a9e89fcff72a7"
    sha256 arm64_sequoia:     "644d3add67ca5e1a68e7687cb71df2ba8350825995dff14f127b0eee8fc6faa9"
    sha256 arm64_linux:       "8513d82ad933e8c2901532bdc52949b72af1eb97bf95ef765d48d1c77e367c32"
    sha256 x86_64_linux:      "f80fbff0896944faf08ec14d757fc5692bfb8861e720d713e2e0d7b585a548f0"
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

class Papers < Formula
  desc "Document viewer for multiple document formats for GNOME"
  homepage "https://apps.gnome.org/Papers/"
  url "https://download.gnome.org/sources/papers/48/papers-48.4.tar.xz"
  sha256 "f11aa1c544ac211259e230b40c804ae64077339a57bdefa3dbbeb57f9166e3fd"
  license "GPL-2.0-or-later"

  depends_on "desktop-file-utils" => :build
  depends_on "gobject-introspection" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "djvulibre"
  depends_on "exempi"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "hicolor-icon-theme"
  depends_on "libadwaita"
  depends_on "libarchive"
  depends_on "libspelling"
  depends_on "libtiff"
  depends_on "poppler"

  uses_from_macos "zlib"

  on_linux do
    depends_on "gettext" => :build
  end

  def install
    ENV["DESTDIR"] = "/"

    args = %w[
      -Dviewer=true
      -Dpreviewer=true
      -Dthumbnailer=true
      -Dnautilus=false
      -Dcomics=enabled
      -Ddjvu=enabled
      -Dpdf=enabled
      -Dtiff=enabled
      -Dtests=false
      -Ddocumentation=false
      -Duser_doc=false
      -Dintrospection=enabled
      -Dsysprof=disabled
      -Dkeyring=enabled
      -Dgtk_unix_print=enabled
      -Dspell_check=enabled
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"

    if OS.mac?
      lib.glob("libpps*.dylib").each do |dylib|
        if File.file?(dylib) && !File.symlink?(dylib)
          basename = File.basename(dylib)
          MachO::Tools.change_install_name(bin/"papers", "@rpath/#{basename}", "#{opt_lib}/#{basename}")
        end
      end

      MachO.codesign!(bin/"papers") if Hardware::CPU.arm?
      chmod 0555, bin/"papers"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", HOMEBREW_PREFIX/"share/glib-2.0/schemas"
    system "#{Formula["gtk4"].opt_bin}/gtk4-update-icon-cache", "-f", "-t", HOMEBREW_PREFIX/"share/icons/hicolor"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/papers --version")
  end
end

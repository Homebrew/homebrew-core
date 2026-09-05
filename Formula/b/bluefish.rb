class Bluefish < Formula
  desc "GTK text editor for web and software development"
  homepage "https://bluefish.openoffice.nl/index.html"
  url "https://www.bennewitz.com/bluefish/stable/source/bluefish-2.4.2.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/bluefish/bluefish/2.4.2/bluefish-2.4.2.tar.bz2"
  sha256 "b2641f9ff8033719e02c519c5ddb4bdadbd7ff73ef252e9287d512c4770377c5"
  license "GPL-3.0-or-later"

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build

  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "enchant"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "gucharmap"
  depends_on "harfbuzz"
  depends_on "pango"
  depends_on "pcre2"
  depends_on "python@3.14"

  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
    # Homebrew's gtk+3 uses the quartz gdk backend, and configure then requires
    # gtk-mac-integration unconditionally to wire up the native Mac menu bar.
    depends_on "gtk-mac-integration"
  end

  def install
    # Stop `make install` shelling out to update-desktop-database and
    # update-mime-database, and registering in a system XML catalog. What each
    # does varies with whatever happens to be installed on the build machine.
    args = %w[
      --disable-update-databases
      --disable-debugging-output
    ]

    system "./configure", *std_configure_args, *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bluefish --version")
  end
end

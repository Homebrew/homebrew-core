class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/45/evince-45.0.tar.xz"
  sha256 "d18647d4275cbddf0d32817b1d04e307342a85be914ec4dad2d8082aaf8aa4a8"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "e03af0664ea68b59cd1cf48a6103442b39b41011c1213c17be63d2d684838cdc"
    sha256 arm64_ventura:  "c4e9dc37d42dd89b29d2d4e7d321826ddefbdf84ce6a456075c34a0013af1809"
    sha256 arm64_monterey: "334f7eaae917ac1f4073a8693740f81eba34cd190b8a16f99785d3609363003f"
    sha256 arm64_big_sur:  "b29f4b6694bb06a50b1d07db20ce7e5fa3e31abe5de6d439d39f1d4b047be6a5"
    sha256 sonoma:         "7e0d5f1f4cb8be6ffc6dc532665c350b33ef094ec2f92c9be716c20e22f776e7"
    sha256 ventura:        "f20de7a8fd7f5bba31f94619bea1302a881baa0122659de7379231e8368c875e"
    sha256 monterey:       "a8d19658c6432684fb582a8cb6583a2fa87c7c221f921a70812868db1e0f49ca"
    sha256 big_sur:        "9ba79c6ccb16958bb63b44600f05cee1ad4a0899859ea897fcabde9788bd0a17"
    sha256 x86_64_linux:   "5fcadf5fe0738904053dff0ece6a4afb50eeb5040d88f35614f084f065d8c455"
  end

  depends_on "desktop-file-utils" => :build # for update-desktop-database
  depends_on "gettext" => :build # for msgfmt
  depends_on "gobject-introspection" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "djvulibre"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libarchive"
  depends_on "libgxps"
  depends_on "libhandy"
  depends_on "libsecret"
  depends_on "libspectre"
  depends_on "poppler"

  def install
    ENV["DESTDIR"] = "/"
    system "meson", "setup", "build", "-Dnautilus=false",
                                      "-Dcomics=enabled",
                                      "-Ddjvu=enabled",
                                      "-Dpdf=enabled",
                                      "-Dps=enabled",
                                      "-Dtiff=enabled",
                                      "-Dxps=enabled",
                                      "-Dgtk_doc=false",
                                      "-Dintrospection=true",
                                      "-Ddbus=false",
                                      "-Dgspell=enabled",
                                      *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evince --version")
  end
end

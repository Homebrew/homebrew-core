class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/42/evince-42.3.tar.xz"
  sha256 "49aecf845c946c96db17ba89d75c8002c5ae8963f504a9b0626d12675914645e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "743b9157e90ae9315e58dd0001dc8b904a813f7377b108cf9719aeec323f6573"
    sha256 arm64_big_sur:  "ef441a3b5296bd0fc410c86258f777d1219c7c0f7d9a2a125f59a592df64b870"
    sha256 monterey:       "e98f0e196356c8adc2de8c4f2c6462ae503c865f04ce027f575d9e2f0f155f41"
    sha256 big_sur:        "c04ea8f76ddc2406b1a3281ae4d9566fa343fd77d8c434243eea6da87a5cfdcf"
    sha256 catalina:       "b2363f06633f3373afc78a360cab08f11c45b1a23d6294103887c869ff0e7a00"
    sha256 x86_64_linux:   "71c54a195b220570d7cb9b40a44021a752d795a61008a8c79cbdab1d40771699"
  end

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
  depends_on "python@3.9"

  def install
    ENV["DESTDIR"] = "/"

    args = %w[
      -Dnautilus=false
      -Dcomics=enabled
      -Ddjvu=enabled
      -Dpdf=enabled
      -Dps=enabled
      -Dtiff=enabled
      -Dxps=enabled
      -Dgtk_doc=false
      -Dintrospection=true
      -Ddbus=false
      -Dgspell=enabled
    ]

    mkdir "build" do
      system "meson", *std_meson_args, *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evince --version")
  end
end

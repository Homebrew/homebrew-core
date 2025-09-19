class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://apps.gnome.org/Baobab/"
  url "https://download.gnome.org/sources/baobab/49/baobab-49.0.tar.xz"
  sha256 "195c0182dc4d7f694dd0b4ee36e72e0f4ab757825fc238233409eec2df483fae"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "0febae35c1f687555a62c18786f78761b8f40e7287b9b6bf0168530a3ec5f8c0"
    sha256 arm64_sequoia: "b5af8085b2a36d02d8587f1b90116eb9b2d5ad3a2982ee33b9d91576be52d27f"
    sha256 arm64_sonoma:  "8b2d77a4774f245504c6a7a7a8d321b802ad66a1cfd7c33845f2ae6412e0e3cb"
    sha256 arm64_ventura: "f697e53a272f314f50ddb0afe4d4fe03d7fa49ee10daa1111128a8e1809979f4"
    sha256 sonoma:        "f2ef838e9a6796ed2871257c533ff2a12add44a97cb81ad3aef99980d2c563f9"
    sha256 ventura:       "41a620af55c2d4e008486e7bb63c26dc589c20ad67f0589aba52b115300b85b0"
    sha256 arm64_linux:   "42a76e3bb4163c7e6f35936ee60520b04b2de06eca9658e000073821a1026abe"
    sha256 x86_64_linux:  "d88be91ce42ac7d800449d863d94e32f97ad3ce469b5a9a401d10e37b3b1a114"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "gettext" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "vala" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "glib"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "hicolor-icon-theme"
  depends_on "libadwaita"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  def install
    # Work-around for build issue with Xcode 15.3
    # upstream bug report, https://gitlab.gnome.org/GNOME/baobab/-/issues/122
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    # stop meson_post_install.py from doing what needs to be done in the post_install step
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk4"].opt_bin}/gtk4-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/baobab --version")
  end
end

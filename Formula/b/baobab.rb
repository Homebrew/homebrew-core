class Baobab < Formula
  desc "Gnome disk usage analyzer"
  homepage "https://apps.gnome.org/Baobab/"
  url "https://download.gnome.org/sources/baobab/50/baobab-50.0.tar.xz"
  sha256 "573c84f15f5f963a440500f6f43412c928ac2335f6b69dcb58f1a1fe5201024b"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "e7e8fdd100af709c6498bf6e52ae10b1a112e17a7bed316df7c176080b0763ce"
    sha256 arm64_sequoia: "c4704affacdd5892cdbeae931c8806b9aff5f448bdc84aed9284f406a1f466ae"
    sha256 arm64_sonoma:  "ddf89d0b8396df36f671658f788aa68bd24aa29e2af95f943f5c3663aea140d8"
    sha256 sonoma:        "c3b14213ba9c3793909d17b1935dc7149a7db3b8a3ce5e37436c9064d95688a4"
    sha256 arm64_linux:   "40dfcc1db2ad7ff101f3067a1e219b581e02513f350280d8ce60c5fa31bccebd"
    sha256 x86_64_linux:  "9a6869ea1a27bf528b72b1bb7dd68357be29912d0f52bf05cb09878f2fa1d9b9"
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

  post_install_steps do
    compile_gsettings_schemas
    gtk_update_icon_cache
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/baobab --version")
  end
end

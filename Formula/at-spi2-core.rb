class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "http://a11y.org"
  url "https://download.gnome.org/sources/at-spi2-core/2.28/at-spi2-core-2.28.0.tar.xz"
  sha256 "42a2487ab11ce43c288e73b2668ef8b1ab40a0e2b4f94e80fca04ad27b6f1c87"

  bottle do
    sha256 "f47d8d5a2490d9455e366642b150b2466bcf8a2f3c2cea6e46e61f75f2d14898" => :mojave
    sha256 "8b86b7d87d5cb4ee218dc60c6b8e27b4d3a89b6a82599423e0fd5edb40e71c3a" => :high_sierra
    sha256 "7434c8470321ce6eaf7e0e8ae770b74234c861f912bba3fb1d81177bbd337478" => :sierra
    sha256 "76ad7476a165d57556940a9511d640e812a1b87d8148814e8a1a735217475822" => :el_capitan
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson-internal" => :build
  depends_on "ninja" => :build
  depends_on "python" => :build
  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "dbus"

  def install
    ENV.refurbish_args

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    system "#{libexec}/at-spi2-registryd", "-h"
  end
end

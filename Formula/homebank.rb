class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.5.tar.gz"
  sha256 "dedaa6b02c505cd02c0ec2dd8b2ba4e0cc9d1f45a01eab0da60ab1bc2a7e6c75"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://homebank.free.fr/public/"
    regex(/href=.*?homebank[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "96d1b2970dbabefad1f94368258c8457868434983a7c6ba189b509378139ff3c"
    sha256 big_sur:       "6e413ee134c65cb503b5b887340b0d0c7ee5da38fc87962410fadb902a3e867d"
    sha256 catalina:      "585334fcd41f97c64bdb16c1f7c8494f426d4192ad2d96f99a8620b18dac8284"
    sha256 mojave:        "792c4a0526e2c390dc9a00f0decd3e2694ddaed21a8462b27f1eda9a22f27782"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libofx"
  depends_on "libsoup"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-ofx"
    chmod 0755, "./install-sh"
    system "make", "install"
  end

  test do
    system "#{bin}/homebank", "--version"
  end
end

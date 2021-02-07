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
    rebuild 1
    sha256 arm64_big_sur: "d08ab0fa40f4b94917a8794da31f8c6149df98ba48ef5a49b39511d78d55ffa0"
    sha256 big_sur:       "48cd56a0f840fedc0c6e4943e149da832ed2d0b86f5fef6f09b2da7402e5e656"
    sha256 catalina:      "d985498d9c7916903d550cc5871e32c3730878f544aec6fb875d2c22768913ab"
    sha256 mojave:        "e884c6c2ee8682be2a7895af8b8c001e8d59d8e1c28586302fabcaca622cafd4"
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

class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.1.6.tar.gz"
  sha256 "2861e11590a00f5cbc505293821cb8caeabb74c26babe8a6a9d728f3404290e0"

  bottle do
    sha256 "c056aa19d55d4c4470617d1d9293ee9be203b1748e1a614eb8b845a79cd5619d" => :high_sierra
    sha256 "11d517acb75ce5e4d50318dac619adb8bbb7d0928baec2c90a98fc59040fa303" => :sierra
    sha256 "6195045b9cb914527e110b14d4200b47d39e0ca3337437eee5c62218b20388c8" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "gtk+3"
  depends_on "gnome-icon-theme"
  depends_on "hicolor-icon-theme"
  depends_on "freetype"
  depends_on "fontconfig"
  depends_on "libsoup"
  depends_on "libofx" => :optional

  def install
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}"]
    args << "--with-ofx" if build.with? "libofx"

    system "./configure", *args
    chmod 0755, "./install-sh"
    system "make", "install"
  end

  test do
    system "#{bin}/homebank", "--version"
  end
end

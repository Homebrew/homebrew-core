class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.1.1.tar.gz"
  sha256 "9cd36ddc6931fd95ef5bcc6a723b3df0651b32e19465570d223c21ac1d5aa4bd"

  bottle do
    sha256 "afdcc307dfa1548fe01b0156bfd48aba2ac1145cdeddeb1ab49be81e0c81d36c" => :sierra
    sha256 "357947cfd34a05111838cc58fe16f6e97891fb8bc94274527566daa6a592fc4d" => :el_capitan
    sha256 "c1567311d0a37889c3e92e7ac3dde4385e18a44cee664c237850ed0deb5285d8" => :yosemite
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

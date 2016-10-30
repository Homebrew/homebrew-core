class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.1.tar.gz"
  sha256 "5b689aecaf9abddd8fbcee043f9815e26ad98f585d63a1db8d4469493c32e7d9"

  bottle do
    sha256 "0513944534cd20c7acd42e6ad1efaeb39af91dc881b20085eb919229dc1fb836" => :sierra
    sha256 "5b5b56af40d55481dcf67691973ea5e500795f5aa60eec5b1fdb48e912dbc36e" => :el_capitan
    sha256 "31849ddb3f919faf4e9e7f9d14804ba5baf2c9a57484c8764bf680c8458c9266" => :yosemite
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

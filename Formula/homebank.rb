class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.1.8.tar.gz"
  sha256 "1083fcbc609cbc981a42c63d84a09cc7dc3dd40f57d29e08b720be2b3eaff23b"

  bottle do
    sha256 "4a74deed6b61f331160c784d23e71c26aae592f5d69754ce8043ec50d848f0bb" => :high_sierra
    sha256 "38bf9acb783027f85f0c831ede56b2fcb8cbd32bf0e78c1acde3c2b0c2f102dc" => :sierra
    sha256 "cf9cfc4e6209c91d4895e9dca8fcf80b9faf7874cd2f9496dbce60ce2fb968ff" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "gtk+3"
  depends_on "adwaita-icon-theme"
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

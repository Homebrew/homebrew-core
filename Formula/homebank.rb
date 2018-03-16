class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.1.7.tar.gz"
  sha256 "579e53c00764b78d79e8e388b9202c760a9c9efdaca83b32d948f92e0dfa5fa7"

  bottle do
    sha256 "cba415fe76d1f4bf9b916d1628dc53aded35b7a9efe09b2242c62f3cd377a9b4" => :high_sierra
    sha256 "04ab35bf95eda56936ebc23d23b06d83cfb582e2c0dbb6b8c9117640815638ec" => :sierra
    sha256 "ac847e14ffb2ce44292172b79464a1500991244b81c6d66235408adf2f386173" => :el_capitan
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

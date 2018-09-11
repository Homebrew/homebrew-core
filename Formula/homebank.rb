class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.2.tar.gz"
  sha256 "8e5421e0f3e782bb403f26d713791671e0e51d887157169d915637e54e720908"

  bottle do
    sha256 "6714b6331c71bcde205ec1ec301331fe3355d64ca29801f09f9a547e343cb1d6" => :mojave
    sha256 "d62df5ebd994fa030be7667bb8fb75ccce33d4c557554e19300ef48c1a960f5f" => :high_sierra
    sha256 "486d1d5f5d8d2132d2d1cb814e68b6d1241886b2746fc083886dc0068c5b2eee" => :sierra
    sha256 "9766b5b98e8386e815d4851be914cc0306526de66cb35d99eb022371af0a0708" => :el_capitan
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

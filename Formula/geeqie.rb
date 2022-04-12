class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "https://www.geeqie.org/"
  url "https://github.com/BestImageViewer/geeqie/releases/download/v1.7.3/geeqie-1.7.3.tar.xz"
  sha256 "25b1f71cf91bd9a96f399d2a9e70507e54bb377a56e64d89521c0f7a9ce5dd38"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "a5255f0fd09c964cbe3c22782cd40e4144ec14ec1ac8c85e390674788981c235"
    sha256 cellar: :any, arm64_big_sur:  "1cf09fc46064b757adb7c290419dd8a08afcb11c18f9686c4c7aec66416529bc"
    sha256 cellar: :any, monterey:       "4ef1d3cafe52e385eeb1a750b5eada40955db638105e3c7a50769799897fe6d0"
    sha256 cellar: :any, big_sur:        "d4c12350ca443f6d9dc769c5f3659940a6ad3a51051bed033356db35414626de"
    sha256 cellar: :any, catalina:       "32ccfb7d8809d755c11856d0cbd064088bd91c6928d0eae032c0d52677b111a2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "atk"
  depends_on "cairo"
  depends_on "exiv2"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "imagemagick"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "libx11"
  depends_on "little-cms2"
  depends_on "pango"

  def install
    ENV["NOCONFIGURE"] = "yes"
    system "./autogen.sh" # Seems to struggle to find GTK headers without this
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-glibtest",
                          "--disable-gtktest",
                          "--enable-gtk3"
    system "make", "install"
  end

  test do
    system "#{bin}/geeqie", "--version"
  end
end

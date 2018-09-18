class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.2.1.tar.gz"
  sha256 "7fe1dd487bca1115e59d7668aeb4de32eb8ce1964f74d24ceb28694736597744"

  bottle do
    rebuild 1
    sha256 "1415637e372f7cb1b9e9149e20e0251a1fcec59d04d4524889010c87b84c41df" => :mojave
    sha256 "577622794a58c1c55d6972fc1ec338df9a4cfca664eb9a118bb58993cf8e342a" => :high_sierra
    sha256 "2a155e05b50ffffcb25d42f56c5ee8d1c246693a25452657f0516b0171315f61" => :sierra
    sha256 "10465995b0a5b3a0ae35d6bf27be427e69e251d809c810f51aba910dc81c3056" => :el_capitan
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

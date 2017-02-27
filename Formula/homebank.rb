class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.1.4.tar.gz"
  sha256 "0af35f848c9be864db838868c14977e3f873b54b20be24b6b30189766c5afd1f"

  bottle do
    sha256 "933eef64969c5be645c0025439fd89b5fc7c7d3ffed6f3a0edbee85975ef70d8" => :sierra
    sha256 "eab5d6f05426ccb46f6bc24d6462f1185ad32cd7e77d4f14c2e8e330f8c84af7" => :el_capitan
    sha256 "03852ca34e14fdb4de307e8c513be4bcb795ec831588bb59daed61e42891c70e" => :yosemite
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

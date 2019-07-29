class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.2.6.tar.gz"
  sha256 "9a14cbf7029080f208d76b27a2d8066964426685ddc86fd1abed30bd428c9881"
  revision 1

  bottle do
    sha256 "08ccd3d0a38a63e644bfcb48cc9e0d3b66dbe5a42e77edd817a2b1602112cc34" => :mojave
    sha256 "89fdc06aceed277f7a502b47dd279ab092f68ac19b2fc6260719ba82b3f48fa2" => :high_sierra
    sha256 "8ae8f4df0676d99f3f49c356def441b4b4522f9a8bf030b0d7fc3c8b56e92bbe" => :sierra
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

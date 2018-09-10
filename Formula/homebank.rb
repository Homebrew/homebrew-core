class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.2.tar.gz"
  sha256 "4ee3a987eaccd7f419c15fab7cde2793b063a89f6eb3eea4be57d8a6b4fd3624"

  bottle do
    sha256 "95c5ffa07316efe39f9d4a786bc665520dd93230dd7e2f5ad3fe126da5949b1f" => :mojave
    sha256 "c707ac6ee4d62d6bb72302915188d2d07deb3fabe38a91c907e93037aecd4d0b" => :high_sierra
    sha256 "d0ea1d56222a494e67b60dbad29892a8376be5712ecb59ade3ebb3611d292b8c" => :sierra
    sha256 "cfb98afe0dce332cc996ea309b801cc66d8afeb0ec15fcb5568aee4b29a82950" => :el_capitan
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

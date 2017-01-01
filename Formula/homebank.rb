class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.1.2.tar.gz"
  sha256 "d0dd12fcd41e2a23879a3f8378008436abb011d6cb7b0da9268f213d68c1fa27"

  bottle do
    sha256 "ccf08d55aea7f5d8bdde251fe0643e95f8876a88a106a4031bbf0461bd44a7c3" => :sierra
    sha256 "6e749165dbe312c2c4340a49de8941e222091d78167078512e9d7647758cd8f5" => :el_capitan
    sha256 "a101dc5896fa99fe746eace3f4e8bdb5061d11fceb92112ecece532a4df485ff" => :yosemite
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

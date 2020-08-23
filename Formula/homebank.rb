class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.4.2.tar.gz"
  sha256 "c6ce84b421e7199ae545ea8b8d981f347af4d67b4cd5912b6789cf1450db722e"
  license "GPL-2.0"
  revision 2

  bottle do
    sha256 "0e4ff7e47759a74db8b8cfbaf632888406b554ce188ace0669f73f406e54f61c" => :catalina
    sha256 "22b171f0962aec50af0000c9bab0a5ae74ced93f983bb5e3fbc73d50a942a385" => :mojave
    sha256 "ff27bafb5edfb5bf04adf586d64e7fbae87760ff23b214795eb280cc4f48568d" => :high_sierra
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

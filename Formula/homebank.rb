class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.2.4.tar.gz"
  sha256 "79a89ab8816a5973fa6afe75157fa375953795c79c224d510e8af0afed2512d2"

  bottle do
    sha256 "3a849cf6fafd639e698d768ea98407ba74843ae914261d3bb4ce275ca3c5408b" => :mojave
    sha256 "f9796fb5c834b38bdc616a63eda90edf0ff6ef89c06f43edc727b202835192a3" => :high_sierra
    sha256 "f7aef9c4caad70fcff9ae49fb4ac05c03bf8876f0c48648ea326ac94829f7dc2" => :sierra
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

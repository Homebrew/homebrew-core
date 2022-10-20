class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.5.8.tar.gz"
  sha256 "507a5bb3ceea230780f11206728b061daac00f654b52e782aab875ab71abcf85"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://homebank.free.fr/public/"
    regex(/href=.*?homebank[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "214e609aefe8a8793ae0f8757ab971685526d2a078e9e69026458684054924be"
    sha256 arm64_big_sur:  "70ed29226013af9eba03840ddc08c903864ee7dea75ab45329c54e12bccc680d"
    sha256 monterey:       "e0244641f0d8c8bc24acf0b6fe603557cb30bef7912286a0d9e18ec31a1c98e9"
    sha256 big_sur:        "e9ccec7c7bb765b8655db66b42397639da7c62d7dbd287176565e895e005dc5f"
    sha256 catalina:       "e1db723e3f8c67cb74de784597fb17ba0a07861a1e67b58752057040b759b4c6"
    sha256 x86_64_linux:   "c42d840ecdc2bef16bd974d304ab61dfa80cc9109d867a81d0a85d6287713a1f"
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
  depends_on "libsoup@2"

  def install
    if OS.linux?
      # Needed to find intltool (xml::parser)
      ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5"
      ENV["INTLTOOL_PERL"] = Formula["perl"].bin/"perl"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-ofx"
    chmod 0755, "./install-sh"
    system "make", "install"
  end

  test do
    system "#{bin}/homebank", "--version"
  end
end

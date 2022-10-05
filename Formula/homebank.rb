class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  url "http://homebank.free.fr/public/homebank-5.5.7.tar.gz"
  sha256 "ada0165f2883ca47af3cea8907c05e6080bc2d04274deebb58bd84b00c3b2838"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://homebank.free.fr/public/"
    regex(/href=.*?homebank[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "d3942b46c0d90533b536d564245191447fd58a7087a8d2815d8b87115a7f8c26"
    sha256 arm64_big_sur:  "786d5427f5aff89547e49d67e84359c323978d30bd91924c9c603d68dcf55a45"
    sha256 monterey:       "9012a989128ede978dcd368cd2331d1b36071c0efc50f37ee5a7a45668879be0"
    sha256 big_sur:        "6adec64333bdedaaa05d9a48fd48060deb1d53b151290f3e8eb61ff174a6f322"
    sha256 catalina:       "7ce00bc18446f6b1c85bdc17c9d976467d7cecd49446f506c40725af5dfae001"
    sha256 x86_64_linux:   "c433ef2a4d2f7f7085d74a77d16dfe54489024d245733eca4f4a77c356b64d6d"
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

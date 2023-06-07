class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  # A mirror is used as primary URL because the official one is unstable.
  url "https://ftp.openbsd.org/pub/OpenBSD/distfiles/homebank-5.6.3.tar.gz"
  mirror "http://homebank.free.fr/public/sources/homebank-5.6.3.tar.gz"
  sha256 "419475f564bbd9be7f4101b1197ce53ea21e8374bcf0505391406317ed823828"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://homebank.free.fr/public/sources/"
    regex(/href=.*?homebank[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "8137d3e7f623c9a6a35eeaa4bfe68d23d25da9a9867c2894feda6debcc2b1ebc"
    sha256 arm64_monterey: "e556fb2203454cedcb4a6a198170ebbfa06f24a966c2644f3238d1cd0bd2a49b"
    sha256 arm64_big_sur:  "e6d1f0d465c5bb0187ee2df56772577a05a712f75d441ffd8d60b33fea930455"
    sha256 ventura:        "8110f5df28dd966d24d6a580eea69b244e8cea52b9769cd129e2baa7e3d2e9b6"
    sha256 monterey:       "84b9065b87f5320daf6b5b2777557330965d187fb2439184d9489463f998f5cb"
    sha256 big_sur:        "e3f007a111e9c2b0b4e2fe5beee8d7292cc37af57546b9b6f2585b84116f1c46"
    sha256 x86_64_linux:   "3470b8d8f9d650a3ad8da55830d9ae5de162262dfba3c75dcdafeb800b2aa1a8"
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

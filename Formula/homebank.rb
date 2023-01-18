class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  # A mirror is used as primary URL because the official one is unstable.
  url "https://ftp.openbsd.org/pub/OpenBSD/distfiles/homebank-5.6.1.tar.gz"
  mirror "http://homebank.free.fr/public/homebank-5.6.1.tar.gz"
  sha256 "3a489c31c553269ab8aa014fdd0eea90fc21d5715e8c1dc5d0feaf730ef38f0f"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://homebank.free.fr/public/sources/"
    regex(/href=.*?homebank[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "7dbe4fd7d480ffdfef2e2951081826f25a0ac3586ed618bb4dd2f00b55e8f9e9"
    sha256 arm64_monterey: "379a20865c313d6b26549ec8da7dcd368f02e10a6b2bc77c31db8e95f75f0be3"
    sha256 arm64_big_sur:  "bd118d5fcb8817dbc1156ed31c44932f963d491e07cd1b200a6c8874df7bedb8"
    sha256 ventura:        "967da1885c774f70c9eba5911715b56df7692369dac50556ceaa6f9f6749ac08"
    sha256 monterey:       "4d647032ba62a513be8912b691b87c1b4526350c4af8dc31ee2312a69989ed4f"
    sha256 big_sur:        "232a9ff32e5bb37cc39f2b7bdebf82543b2dbf0330199190d1d14dbb2a11696d"
    sha256 x86_64_linux:   "1b2c0d24174ca0709cb49bcb35e69ffa17294c0748b5cdb4fb6335ada3ee76e8"
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

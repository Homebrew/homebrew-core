class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "http://homebank.free.fr"
  # A mirror is used as primary URL because the official one is unstable.
  url "https://deb.debian.org/debian/pool/main/h/homebank/homebank_5.8.6.orig.tar.gz"
  mirror "http://homebank.free.fr/public/sources/homebank-5.8.6.tar.gz"
  sha256 "af138a7bf2cd795c1338c5e3d9e99909ee6b33d920c618dc35c6477fd826ddf5"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/h/homebank/"
    regex(/href=.*?homebank[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "efab141f793847482f16f90362916f2f09937a6baa3c892df30fe04e3de6b86a"
    sha256 arm64_sonoma:  "a75d764da8a08f87a173194d81d821ee201636295a9522ac96dad5fd52e679b6"
    sha256 arm64_ventura: "f7a05e75f18dedecb7a07fa78a1f862b8967274018824829ff33c8efe88aaf70"
    sha256 sonoma:        "8c979f17c79bf993edbb449c5f2be3f6d2a8123321125cb64744ca1bd15b35e3"
    sha256 ventura:       "7e8692240976b9a05c7e36ea7fd9f5e0b4af9a41e79918d2a0bb63967bcff906"
    sha256 arm64_linux:   "3f0ae5cd4b908fbcbae49b32b219fc61c712020a982209e0707881c077cfd2b1"
    sha256 x86_64_linux:  "096747e583c538a312c20b541fc8c7388001d86ed9cabb01a0e949d55c3e187c"
  end

  depends_on "intltool" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libofx"
  depends_on "libsoup"
  depends_on "pango"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    system "./configure", "--with-ofx", *std_configure_args
    chmod 0755, "./install-sh"
    system "make", "install"
  end

  test do
    # homebank is a GUI application
    system bin/"homebank", "--help"
  end
end

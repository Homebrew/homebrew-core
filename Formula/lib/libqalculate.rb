class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v5.7.0/libqalculate-5.7.0.tar.gz"
  sha256 "b0aa7e7f6b729ad88f41c3562e81bdc349e072f4df0e62ce152304d979702cfe"
  license "GPL-2.0-or-later"

  bottle do
    sha256                               arm64_sonoma:  "70e9f4769ea5f258c3958a96406bf882dfa4deaa33b6acd52d227bfe24c5b28a"
    sha256                               arm64_ventura: "1b8390d632cc76910b2479502df78df1f8cb0b5f733c594d8b9518034331da21"
    sha256                               sonoma:        "63e76cccbd23e2ac3c362adbc76b9e0b152381e74cd271ec7dccd50349c3e8b5"
    sha256                               ventura:       "8997d64a7f5164811710cd537ec8613bcd909f9b0f6a3514cb07b00daff9f8dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c535e5312b7c71f0cd7110bc85f3a49ded8902fb743bb4b4314ce64e03f8bfe3"
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"
  depends_on "gnuplot"
  depends_on "mpfr"
  depends_on "readline"

  uses_from_macos "perl" => :build
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    ENV.cxx11
    system "./configure", "--disable-silent-rules",
                          "--without-icu",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"qalc", "-nocurrencies", "(2+2)/4 hours to minutes"
  end
end

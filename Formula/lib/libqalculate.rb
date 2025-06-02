class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v5.5.2/libqalculate-5.5.2.tar.gz"
  sha256 "fc14d4527dccfc9189684b9fcd64d78aa67ae5383012c66e1596b2531f5daef1"
  license "GPL-2.0-or-later"

  bottle do
    sha256                               arm64_sonoma:  "3eda9b1f7607de60bf38b405285ead9593f2c94eba85fa8b7fdb90919899c771"
    sha256                               arm64_ventura: "880ef6188d9cea8c037ba39330c5bbf2e5fb784d69da9de1251f4c25810e308e"
    sha256                               sonoma:        "cffd7934a442261cbec625311eeee167e3d5eb6d474a1d7ffa8b2cb48d73fe17"
    sha256                               ventura:       "3ae202875fa805ce960397b3998dd82f53de64901638232cb47c2d11891f09d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9276262afdc1f8f61d964d9527c27073f55c84f6696b3ee764a583eb27df8b81"
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

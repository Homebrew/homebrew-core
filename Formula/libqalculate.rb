class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v4.1.1/libqalculate-4.1.1.tar.gz"
  sha256 "b5611a91293be40fbe8723a81937e25ffb54e6ad6e60f282d044ed92f2d97002"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "51223e387b3e266d4e3164e7ce0f70a491795bcb3d23a01282ece8c852a58a7c"
    sha256 arm64_big_sur:  "719bb2e428ef547f4ed259dd72ed7cbac7ab1adee98cbb4bd280205ad9a520d7"
    sha256 monterey:       "b69ad7f0bb0c7b2bc0549cf4b178f5aed2515509de6147785acaa1e4a3706aff"
    sha256 big_sur:        "eac439b4d69a0fdf15a32db34a9b4dbb96a8e0475fa27df826a3891972c31b1e"
    sha256 catalina:       "1eca3c358a46786d35dfbf6dbfff9428eaed71ea9798f119f9087dc6d5f6659a"
    sha256 x86_64_linux:   "ad0603e0e68e6a2f1451cd36c454fdabd1acda18c315247f4988d56de709d87f"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "mpfr"
  depends_on "readline"

  uses_from_macos "perl" => :build
  uses_from_macos "curl"

  def install
    ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5" unless OS.mac?
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--without-icu",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/qalc", "-nocurrencies", "(2+2)/4 hours to minutes"
  end
end

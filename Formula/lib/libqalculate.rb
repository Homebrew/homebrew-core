class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v4.8.1/libqalculate-4.8.1.tar.gz"
  sha256 "a55fbdc14cb183c62a95e430823017b5f958f0758d3476578f8cc05369157c54"
  license "GPL-2.0-or-later"

  bottle do
    sha256                               arm64_sonoma:   "4fbdcbac052a935359cc161b8600eb21497bf8bfb9988a8940dd5dc2a0ad67bf"
    sha256                               arm64_ventura:  "4c9a4d8618d5e8ed3dd4624647e96b38707ff834dde8a5156c9ccb8e457e810b"
    sha256                               arm64_monterey: "b70536e9dbbf78b8c32826d1b7c923b001fb19d63b1cd4ffbf74bdec856c5c96"
    sha256                               arm64_big_sur:  "6181e366634d910d88bba46e09112167d474325ea1d3ac2d8da4664502754c40"
    sha256                               sonoma:         "dea8eb89c3864c4b8409e206e8a9f773fcef4ab36be46d1546536bad5abaeae7"
    sha256                               ventura:        "e0523a2ed7938e0739b419f96918b5a8882e7edcbda33e50f2dce967b04c0875"
    sha256                               monterey:       "1ef9b50a7f26324a8aa8e1104dd2dbfb87175de9506f569f64aa41854711f67d"
    sha256                               big_sur:        "18ccf3e7480764f553df5527fc535c75e9d3152da41205d40fda55a29807de2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4dc9812fbe663c3f79730b45e9cfb7de9216c616d12ea0b304eca4a513cb2b9"
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

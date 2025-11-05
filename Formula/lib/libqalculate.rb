class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v5.8.1/libqalculate-5.8.1.tar.gz"
  sha256 "59588d69475cbb374b0b90ddef731802edd5b2da696ef706d0ca5fff4dbcfdfa"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256                               arm64_tahoe:   "ec337d00b94f6f27628c8bbf8d9c8f1f36fec98fa9d909d2f3c152de88db5d76"
    sha256                               arm64_sequoia: "4b833202d6e00904b44d105deeddd1896eba2d9f274b33717961f54255749618"
    sha256                               arm64_sonoma:  "040c8a336a4835a752f2a6e8f83d59a4e3aa1ffc56111a3a334d4024e6372696"
    sha256                               sonoma:        "ea172d11886076ca8b86a448c263a8f791105cdbf2befb0c25759efcb4e50b2a"
    sha256                               arm64_linux:   "a6605f666644dd4e3d7cb45feb5e1b00f937f4abdb06eb8048b6f2579b89408a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1700e71c9d8d1d500fbfe9d18434b040486f644179635a0331e95e9e5f5265d5"
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

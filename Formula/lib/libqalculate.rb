class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v5.8.1/libqalculate-5.8.1.tar.gz"
  sha256 "59588d69475cbb374b0b90ddef731802edd5b2da696ef706d0ca5fff4dbcfdfa"
  license "GPL-2.0-or-later"

  bottle do
    sha256                               arm64_tahoe:   "2c7489f15bcf69204fae78d6a1c4720bb8fafb3fc4b805b65c836286f44f9dca"
    sha256                               arm64_sequoia: "e5e186e45e60d840c63b2196a823ea81c3b0c267d6852470409640a144cda22c"
    sha256                               arm64_sonoma:  "b4e7714e4d403531f3803346d745fe8dd42bb1420c178ab511b7465a6699f422"
    sha256                               sonoma:        "550bad57a313f590ee59417eb231006924f6743bddc34ce92f1a98cb5a573fd5"
    sha256                               arm64_linux:   "2c9162a39f4de4805deb6fb26d85ce1cb83672f4d1dc8c75dec31cb90008049d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "461a633171a7fbe76c4fdc7b4047bb0fcac578652c6a3ca8514228a8ee94f00c"
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

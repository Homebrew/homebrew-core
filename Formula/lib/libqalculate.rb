class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v5.12.0/libqalculate-5.12.0.tar.gz"
  sha256 "f3dfdcf97d5a9e3a5bc0ebe66afd184721b606276eee3ba0ada8c92a5e71d44c"
  license "GPL-2.0-or-later"

  bottle do
    sha256               arm64_tahoe:   "c212ce2764331daf748b7eda7f4ada15a222e8c91f75922d4df00085e75606ea"
    sha256               arm64_sequoia: "e9744a6ccae899134f85439d0fe292025da639b2ad0e58030ece17c3e5fa82fc"
    sha256               arm64_sonoma:  "4c7a9ca3043e5b9499ab262fbeea5b5b5754e1fd367da759395cf24094093137"
    sha256               sonoma:        "447249a44fa9077608f311db835494075146dd933a317a6be038ec321c87641d"
    sha256               arm64_linux:   "38ec999a5433c2a2f3284609967aefeff60e02bb156dfba07a4e3bae00dca3bc"
    sha256 cellar: :any, x86_64_linux:  "64865b1886fba3bacbbeaa5a89d44437fa9c1ec23f0466c7796dc2dc94c4c86e"
  end

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"
  depends_on "gnuplot"
  depends_on "mpfr"
  depends_on "readline"

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
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

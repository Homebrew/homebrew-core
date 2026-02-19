class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v5.9.0/libqalculate-5.9.0.tar.gz"
  sha256 "94d734b9303b3b68df61e4255f2eddeee346b66ec4b6e134f19e1a3cc3ff4a09"
  license "GPL-2.0-or-later"

  bottle do
    sha256                               arm64_tahoe:   "55402534e362fcbe0b2591a6d0e0262acd4e7130aaaa7e95ababa422d021f78d"
    sha256                               arm64_sequoia: "5c6253758b7cb84eb7331d39729f89bcf7c384aac8a9c00c7137cca5d166bac0"
    sha256                               arm64_sonoma:  "4a9b0efd9a4696cf0a23f694a23838874a0ab5059a0f667db5fa83e14583defa"
    sha256                               sonoma:        "c856c5283401b92df0e03872278fd8fc3b4cf05b5e7244e0d460e4557451a17c"
    sha256                               arm64_linux:   "eccd221a8d9f8b92314b9dd989256b8639e784817ddda023e12212ad84172fc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c81d78884537aed382cc63753d15132af9b4e591d872865c2b9e1a85f9f9da69"
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

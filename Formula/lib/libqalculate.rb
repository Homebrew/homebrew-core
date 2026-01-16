class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v5.8.2/libqalculate-5.8.2.tar.gz"
  sha256 "7136f3c929e88e7cea0fa66427bc541dcc99c7ecbe0d67cb256bfc922d2127d1"
  license "GPL-2.0-or-later"

  bottle do
    sha256                               arm64_tahoe:   "1c3c07e45a5cc4356460e349d95a24a9885362632eb86e3350e84b5ff41d23be"
    sha256                               arm64_sequoia: "4adaa1aa5f781ab3f93d8b173d29bf4c421d01b1e5efc234e0ef7f96143e1e69"
    sha256                               arm64_sonoma:  "2c8c0739423f4f353d45d8bdb3944c8841c9a90768d4b785141ce2872fe00ed4"
    sha256                               sonoma:        "4b8b489a6a0d098a672ba249e249bc028ea10a5952ad524105ef0ca6db7634ff"
    sha256                               arm64_linux:   "0b32e0ed93c35dac8315df698dee3dbae7f7385e492fda89002d2e78b2cadae5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ca690b64e729f24000d1867699e2945b3155606f3e995fb3b8e4f8fa296d3ac"
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

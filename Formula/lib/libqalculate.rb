class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v5.11.0/libqalculate-5.11.0.tar.gz"
  sha256 "6217a634eeb9659ebb4080c265dfab47d8f8dd4c33394b48fd5a1f83ef4538c4"
  license "GPL-2.0-or-later"

  bottle do
    sha256                               arm64_tahoe:   "ed0adf5a0459bca27ff106c63a97ca6d9329769601b1bcbdac3b1eb3a1e352a3"
    sha256                               arm64_sequoia: "360ab425b7eb50ebdd9a2752dd277160232c2070e170dc5c2b3dba5234116470"
    sha256                               arm64_sonoma:  "7df821285eb4ea92db45bcb70dbaeb3c76c6b4ea46554b5f5f92d623a98ca573"
    sha256                               sonoma:        "31db71a5ef55601a6898cec0df11580497d4b6269ab413e77830e02f18fcee63"
    sha256                               arm64_linux:   "f66bab9e7f5f6aea7a2037bedecfdc21bc1c8c3675f92c2cf937128df43b2fb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adea8c8aaba9e2acc3212876778f3dac270649c0ece6b14816fe72ec6dd22ae2"
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

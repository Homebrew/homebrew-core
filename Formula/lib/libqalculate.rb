class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v5.5.0/libqalculate-5.5.0.tar.gz"
  sha256 "6d58c6092242ea7cfa137d73abe74b0e3e0a2b59e99c5db60d045b82c673f72b"
  license "GPL-2.0-or-later"

  bottle do
    sha256                               arm64_sonoma:  "0edf462157ca7c12293904001eb9b4b12a999bbcca5a66c2e7820ea41682ebb3"
    sha256                               arm64_ventura: "ff92300b344b8d44fa217245180dc43372e16a2cea39ec610ebf13e326900a87"
    sha256                               sonoma:        "5ee8f4c5e30b6ddf2a098535bd8b65109b14060d1169b4c444173173f1e2b01d"
    sha256                               ventura:       "9565dff55546925f2218a60a61174a47a9b36bb4e828dac154fc82f58ee500a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90335ad19fdad40c64fb402b82e0b6e0e71c6141823e222e839904c309268b80"
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

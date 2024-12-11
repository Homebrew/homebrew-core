class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v5.4.0/libqalculate-5.4.0.tar.gz"
  sha256 "1fe956877ff1bbb1f4b470c41cdf3d971cebbeda6a35e92282f0eea5193ac343"
  license "GPL-2.0-or-later"

  bottle do
    sha256                               arm64_sonoma:  "5e91f7eda5d004a1560a1123fc5ad5458e0f429dc1e308e8f1326ed84fbe5f0f"
    sha256                               arm64_ventura: "2426676ec5818a5cac6aecb75d7a881b3d46248cd4ace86d2d9d47be7368625b"
    sha256                               sonoma:        "928333f3a86483068b3452bfd94e3d4917da1a1ad4efda26a2ef8fe7c25a8a5c"
    sha256                               ventura:       "fb7a6fa06d032729459057d66e1a8f208b48f0ab774f8d5602edbd3e9ec1f8ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2a4524258b85f3cfc277e7f1da310728e5ca837d18cd3ae649b04ad432e1103"
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

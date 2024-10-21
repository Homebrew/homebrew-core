class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v5.3.0/libqalculate-5.3.0.tar.gz"
  sha256 "61dd60b1d43ad3d2944cff9b2f45c9bc646c5a849c621133ef07231e8289e35b"
  license "GPL-2.0-or-later"

  bottle do
    sha256                               arm64_sonoma:  "5e91f7eda5d004a1560a1123fc5ad5458e0f429dc1e308e8f1326ed84fbe5f0f"
    sha256                               arm64_ventura: "2426676ec5818a5cac6aecb75d7a881b3d46248cd4ace86d2d9d47be7368625b"
    sha256                               sonoma:        "928333f3a86483068b3452bfd94e3d4917da1a1ad4efda26a2ef8fe7c25a8a5c"
    sha256                               ventura:       "fb7a6fa06d032729459057d66e1a8f208b48f0ab774f8d5602edbd3e9ec1f8ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2a4524258b85f3cfc277e7f1da310728e5ca837d18cd3ae649b04ad432e1103"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "mpfr"
  depends_on "readline"

  uses_from_macos "perl" => :build
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "gmp"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
    depends_on "gmp"
  end

  def install
    ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5" unless OS.mac?
    ENV.cxx11
    system "./configure", "--disable-silent-rules",
                          "--without-icu",
                          *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    system bin/"qalc", "-nocurrencies", "(2+2)/4 hours to minutes"
  end
end

class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v4.5.1/libqalculate-4.5.1.tar.gz"
  sha256 "230c28f067c02a486252d6ea9a206ffc2b6803ae0430696f9e56611bece20585"
  license "GPL-2.0-or-later"

  bottle do
    sha256                               arm64_ventura:  "3deb5d7f99127a6a57e767bc552672c59913ab5ae609336d642fb6b997d3803e"
    sha256                               arm64_monterey: "69f2bc8316dcd12c8fafca6a032608c3a72941094f00f055d1cd375366a36a4a"
    sha256                               arm64_big_sur:  "317f2b127b2d483884e435ed43c40039ac3ac9ae76be1f741367a38c517071b8"
    sha256                               ventura:        "247f31270b85560ebf2915e1ba063c791afce28b7c23d8a94c00b29e7d630a86"
    sha256                               monterey:       "ab252b90c9e58bd55f90e745d65d1a492f819ece48709b763ace09108790f598"
    sha256                               big_sur:        "e1db413a3aefcb95b10f6c57fc46d7466a84f8d52cb96c139a20587447ed7027"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4035673c98a60759dd8095b2fdd5b567ea70fd29e520e31d0b54e7f224cae93"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "mpfr"
  depends_on "readline"
  depends_on "gnuplot" => :optional

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

class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v5.0.0/libqalculate-5.0.0.tar.gz"
  sha256 "591598dedbcbd80119de052559873530030b3510bca2b0758f088cfb7dafb2ee"
  license "GPL-2.0-or-later"

  bottle do
    sha256                               arm64_sonoma:   "d02e09f3af0fd2a27be6fd6a1703e4390e8100eb1262c16b48e274ee8258d042"
    sha256                               arm64_ventura:  "ffc06bc24f4b3aa50afec39161697aafabff36b1dd5ec2d59acd28f3895eede2"
    sha256                               arm64_monterey: "d9c12c06922ab0cc75e16f31aebaa892e47364d6ff8e924e16bca6f96f91dccb"
    sha256                               sonoma:         "e8327739501ee2bb132bcc892ef9487e459511702fdf807989b91fdd7b33c442"
    sha256                               ventura:        "3688d0dbbd17c7d2361a54cd893a7bbb4ff9b053d8faa0728915b300892e1c91"
    sha256                               monterey:       "131244d7958d62ec9f4c6d67eaed9c836d64e533e6ce3f5f3e71273451522a77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa786ada2f3453b890f8cc980096db1323053f2645c47d58085a7936c5d34323"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "mpfr"
  depends_on "readline"

  uses_from_macos "perl" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5" unless OS.mac?
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

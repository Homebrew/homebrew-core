class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v4.4.0/libqalculate-4.4.0.tar.gz"
  sha256 "79cfdc4d4af9dfcd6902c2ec680ed1f3d5845d07b5ee1c76255fdca731a8b758"
  license "GPL-2.0-or-later"

  bottle do
    sha256                               arm64_ventura:  "d7cb7a82954467dc0623647f7aa570ef5b1b47bc4ed88d3a705aa4f967fb5a0b"
    sha256                               arm64_monterey: "5b8d9b023b2153d4042c97cec6995821f9c84241931fa054449fe9937e100d6c"
    sha256                               arm64_big_sur:  "d4c17c7a04f7f1cd5f3989fb68fc451bc9e2891ffa4b2f0355973bdcb35c1b43"
    sha256                               ventura:        "07b66d62156d3e30f14b0a9ee31868712ee8f9d18657028de4b11c5ffe13c705"
    sha256                               monterey:       "49d4ff7ba3f090971676ec245f8a35d2def4b8ca59c9b2ae52dbf57f47b81492"
    sha256                               big_sur:        "6fd59074edcb41db56f8e4f35eca6ea5e74505f6c26cab09a191560c525efa0d"
    sha256                               catalina:       "efb83a30e40370da78f1c939403bf7e3c986d95de6511df48d6036e871571b60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edb59cd03c5f352355308bd222b46ea3f012145d95f586811ceb0fddb2adab4c"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "mpfr"
  depends_on "readline"

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

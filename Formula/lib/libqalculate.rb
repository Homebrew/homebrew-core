class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v5.1.1/libqalculate-5.1.1.tar.gz"
  sha256 "04db2d1c8dc0d5a006971bb138aa71d4a944275dde8dbf952ad8b59bf499aba1"
  license "GPL-2.0-or-later"

  bottle do
    sha256                               arm64_sonoma:   "f65ed22e56d35f6829a6d5ba455e2426c87dd77030f8cb806f5190a7840210e2"
    sha256                               arm64_ventura:  "971273eec57ab268934f9580e9db7ab98bb562adbfd4d17f376b0879aabf7cb2"
    sha256                               arm64_monterey: "91229982032f778a2c34798c44148daabd92002366e2925ba389b7ac8c02c138"
    sha256                               sonoma:         "7827cf0466d469e327d16c8a923884b5d64179bb31b1e5332b8e19c20c138d91"
    sha256                               ventura:        "3b7be18f85591732b4ee2f36135d4567d154c1fc27005835a5553ed2e649e3e7"
    sha256                               monterey:       "4e62c351526c42d8c2ee79f80a7786e368639354e96ee2a01135a947b7763865"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d8f117178cb6ed7d7d21f3bc6e63cf2b916a7f0fe78d432d939a0b4d9754cce"
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

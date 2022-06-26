class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v4.2.0/libqalculate-4.2.0.tar.gz"
  sha256 "2b86e656508f0b1c55236b08fd579b676563e1500b3db8304580de69c5693e4b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "677ea91094ee82ab0fa1734c3a45ae24ac3c0799e49b814f0a04497a83fd2e46"
    sha256 arm64_big_sur:  "cf8032964ff4d95048724a22bbd419f97c841d482477895b9ab48cc2a2c343e1"
    sha256 monterey:       "bb81e644d65970b7f0a8b910ee01f5ada946cc7962329d4e31f690585f4095e9"
    sha256 big_sur:        "402745609d27f62886f6a58d3f59440c6d936154c13cd8a4e28ba4fd5dc01023"
    sha256 catalina:       "8aa95f8c79aa8490efae1627a2484885488964a267184ebbb7ca5f9a3618e743"
    sha256 x86_64_linux:   "adabd273d324d6bffb81b1fd59fdd6b6827771de97e6bcb2333a004db0b443ca"
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

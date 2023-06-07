class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v4.6.1/libqalculate-4.6.1.tar.gz"
  sha256 "ed087bfdedea0fd0eb26eb37a25e4c55caccfe96d83933a3573c93241458cab3"
  license "GPL-2.0-or-later"

  bottle do
    sha256                               arm64_ventura:  "30316f60023df33288fdca40901bf7b34da072fc97a77300281b25b007b8bd62"
    sha256                               arm64_monterey: "4862585d768ebd85c9bb69b45bb991b1209ec0f9a57cca7b5e909f879d05bcb2"
    sha256                               arm64_big_sur:  "6871325edb9149df752b38ab17fbf84e1c1af790505305cd099c849144cab4e5"
    sha256                               ventura:        "8c4c2cfdfd1479c55bac1d5c69a4cba2896bda70ce5adc1e8f96a49641d385cc"
    sha256                               monterey:       "a7ee64e6e0997908827230197e13e030667d72093704d9032ddee25337fd9083"
    sha256                               big_sur:        "c2c066d0e753927fc1456773b2e016d42cc7c472d6c2722057767db74b071af6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0154a07b3ce5a78ceb5ae82f9496d7fb51413744bd0a0bbdcf94254a0bde251"
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

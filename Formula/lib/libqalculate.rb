class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v4.8.0/libqalculate-4.8.0.tar.gz"
  sha256 "c2761626a061b772da3cec9135c21e9b7ce5aa87a6bb47c9ddd7d82fc8f0f46c"
  license "GPL-2.0-or-later"

  bottle do
    sha256                               arm64_ventura:  "690feaf16b7f3259d5a23f869ead2f62664a0e312bfe91afbb45adace2ff56db"
    sha256                               arm64_monterey: "99414ab25ffcdc673e06769b9867bc04ea9c923849ecae2e2b25a79ac4f34b9b"
    sha256                               arm64_big_sur:  "ce39439cb485cc6ee9faa8eda13a95ec84d5691356cdb6aaa720556d345dd7d1"
    sha256                               ventura:        "c0d4d1342a4e1b4d933cba32df04705a9b3a59cc1142b56277da703e8be4d9ab"
    sha256                               monterey:       "e7ae42c5accb38f363b9e74235a0cc0259399205e75a30bab2e05c648b983f24"
    sha256                               big_sur:        "12851f1c2ee25a7732604e7f01ea23b62f5102f92a9f4234a0a18d23d269c84b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e765b8e17333a845f40f2f6c69001758e8855ca8b011942a5a3de3368399cc58"
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

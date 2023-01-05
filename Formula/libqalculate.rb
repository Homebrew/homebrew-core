class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v4.5.1/libqalculate-4.5.1.tar.gz"
  sha256 "230c28f067c02a486252d6ea9a206ffc2b6803ae0430696f9e56611bece20585"
  license "GPL-2.0-or-later"

  bottle do
    sha256                               arm64_ventura:  "cb7a837a283de4769d94cdf8c9dbe592f8059f68da5f48cbd6726ecbd7fa0d59"
    sha256                               arm64_monterey: "3cd90e7dd56937d1fc28d28a1dfa9db39e519c8a2469082bdb2274b550553ca2"
    sha256                               arm64_big_sur:  "191ecf7a3ed976e35e8c0149d40bb8e574ca2735ef0b7737eac02f8dff40f6e0"
    sha256                               ventura:        "be99a4ab1e212eea0997ef811b122925ca246c0c2dc21147cf56f51858d9c107"
    sha256                               monterey:       "59f967835b437760ef3b95797e1946a78ce1f8c2f14085aeeeb9303199cc3170"
    sha256                               big_sur:        "6fe63706c356ab04b9f05b67f0e6d678c5ca581a2485dd21faf28ce5f228dd2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4940f9912d56dd2f8af9d425beae3e77e1126d45167a39e19d0dbbce42ebee2"
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

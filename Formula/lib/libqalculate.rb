class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v5.10.0/libqalculate-5.10.0.tar.gz"
  sha256 "904592d33a98ed4a26a59fa34c855578e096144fb91965b8afc90e06797dba8e"
  license "GPL-2.0-or-later"

  bottle do
    sha256                               arm64_tahoe:   "72304cd16d5d721fa8c25fffda891d24884016feaa0cbdc2cc956f1929e27e1b"
    sha256                               arm64_sequoia: "7d071d3115a6a06358ef048685a332366291b9b5f60b273e6f9ade31a4b35fd4"
    sha256                               arm64_sonoma:  "0f8223e75e62e374a51530a08693d7e52f7b6ffc0f11c189fdb1353388745e64"
    sha256                               sonoma:        "3b3142f24d074c909634e199a665a162aefb0dad84dc88e4f3fde3981de1ee6c"
    sha256                               arm64_linux:   "7fa0ecaed7c6926cd8b5baf4132746dd4a6be58e909e958f2fb6c68e3e75010a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90d9d1ac9581aa15e84482dbfd571771a6f01478c7e0a3a476e82faaf7993ea3"
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

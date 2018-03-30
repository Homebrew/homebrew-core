class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v2.3.0/libqalculate-2.3.0.tar.gz"
  sha256 "29335b91b5215dcc384396343b03b2bb99cf4e827b7084f84ac32e6a09661796"

  bottle do
    sha256 "643f7a1fbf973bf1fe0cfbf9a214700ec20ca50379cca8471e9ad01d4c3346b0" => :high_sierra
    sha256 "33983c6bb3fa007a959aa62ce9b16567747eb468f761ea7125aa9fe2eab6acb3" => :sierra
    sha256 "3d7ce65151e7832d399b7ff045c269da9fdf35a5ac62fd9c7ef110602f186012" => :el_capitan
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "cln"
  depends_on "glib"
  depends_on "gnuplot"
  depends_on "gettext"
  depends_on "mpfr"
  depends_on "readline"
  depends_on "wget"

  def install
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

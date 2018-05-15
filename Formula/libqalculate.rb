class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v2.5.0/libqalculate-2.5.0.tar.gz"
  sha256 "283098923b9d6cb300eab54dfa67d2b4bab2cac233e08396e28d29042f7e9c83"

  bottle do
    sha256 "6e94803ac05a72c52e6f3634ef5f8fcdb51ff0c769e9bb054c2af7c5838df8fd" => :high_sierra
    sha256 "4f191357f242180e3cbf25041c25a278f2bb7423e2c0b8f73a1e50abe5f510d7" => :sierra
    sha256 "224643d64ac045ebace8e33f71fa6c7ce274eb73e66a6c45fc206ed0cede104c" => :el_capitan
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

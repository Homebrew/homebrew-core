class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v1.0.0a/libqalculate-1.0.0.tar.gz"
  sha256 "7cc5a67356374d7f4fb20619dc4dd7976bbe9ae8d5bc3a40b44c46264de9549b"

  bottle do
    sha256 "cfef7cbb714bef3f00d317a92fd45f2e4d1356e7f6f3a2a852beefbeb83f52c6" => :sierra
    sha256 "dc29c0ab4993ff54d6b53a142547147622646fba99dc5aa5aac5475aeb4c77e7" => :el_capitan
    sha256 "abdd1944a9d09bafa153abcc704ec63f91fbd264ecb6e744279636a5d7cac93d" => :yosemite
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "cln"
  depends_on "glib"
  depends_on "gnuplot"
  depends_on "gettext"
  depends_on "readline"
  depends_on "wget"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/qalc", "-nocurrencies", "(2+2)/4 hours to minutes"
  end
end

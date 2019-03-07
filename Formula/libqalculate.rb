class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v2.9.0/libqalculate-2.9.0.tar.gz"
  sha256 "a4c62f9b097c78a5fbb9fd5ca7b56c03512a23291511e5c7cd4876155ee43575"

  bottle do
    sha256 "c5bafb609c6f73cdca9d59c88d7be3313bdceedc6b8762ff897a4abe9519c45d" => :mojave
    sha256 "77e464b5489e64986cd473595533f5109518154d32d8eb2bf562a8fc3ebea905" => :high_sierra
    sha256 "5b2661a78297a363e8fabdd1c66a3903e626a222707e227b8c955e3f45e575bb" => :sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "mpfr"
  depends_on "readline"

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

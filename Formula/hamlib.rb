class Hamlib < Formula
  desc "Ham radio control libraries"
  homepage "http://www.hamlib.org/"
  url "https://github.com/Hamlib/Hamlib/releases/download/3.3/hamlib-3.3.tar.gz"
  sha256 "c90b53949c767f049733b442cd6e0a48648b55d99d4df5ef3f852d985f45e880"
  license "LGPL-2.1-or-later"
  head "https://github.com/hamlib/hamlib.git"

  bottle do
    cellar :any
    sha256 "45c4558dd261444364a656c8afb48f0ec7a95efe27f2b7e65784687081f6e6c3" => :catalina
    sha256 "cef1ba3b5dcb592c43686f76e9167ee60c19331672164bae5186620d6db7d382" => :mojave
    sha256 "1a347bc581ea06ee93d2c2ddf955f54a6997484b91aabd304fdc077bd70936b9" => :high_sierra
    sha256 "eb3ce94a8e752ab792dd306221b74d0a254695d64bd818fbb841ef068b6b7600" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "libusb-compat"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rigctl", "-V"
  end
end

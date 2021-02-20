class Libsvg < Formula
  desc "Library for SVG files"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/snapshots/libsvg-0.1.4.tar.gz"
  sha256 "4c3bf9292e676a72b12338691be64d0f38cd7f2ea5e8b67fbbf45f1ed404bc8f"
  license "LGPL-2.1"
  revision 1

  livecheck do
    url "https://cairographics.org/snapshots/"
    regex(/href=.*?libsvg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, big_sur:     "96c398556141fc2ad73955de0c52a0217eeeb627102099592d1ccc85250809c9"
    sha256 cellar: :any, catalina:    "e0f21af595963a7c99ffa098f593f5d46cf5f78facf1df84ffe97858f29fecbe"
    sha256 cellar: :any, mojave:      "3984d65fa6524a142ad9094aa095f106ca9c8b6857cdd3f62b913e7e3c8f5b65"
    sha256 cellar: :any, high_sierra: "7cfe0b5417654beb7092afec3389a14a4c67eeaa760eb77c9b28082e40f0b11a"
    sha256 cellar: :any, sierra:      "c9435455e3fb30ce81d467edf1cf4c15c39fb1d061c21738007d6af2565455a7"
    sha256 cellar: :any, el_capitan:  "4e7903c15847c2d07a2bdf16d6ddad5a0191ef452cf7733624703fd1b5fd7859"
    sha256 cellar: :any, yosemite:    "05c230ab37e4f4a3b854373b5c71b275414f852d1b776a60351c0fd49c31674a"
    sha256 cellar: :any, mavericks:   "a6de74ce690bcc7dffd353139182dc0d896250cdca652c315356349f7e78729e"
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libpng"

  uses_from_macos "libxml2"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end

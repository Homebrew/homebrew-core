class Libunistring < Formula
  desc "C string library for manipulating Unicode strings"
  homepage "https://www.gnu.org/software/libunistring/"
  url "https://ftp.gnu.org/gnu/libunistring/libunistring-0.9.7.tar.xz"
  mirror "https://ftpmirror.gnu.org/libunistring/libunistring-0.9.7.tar.xz"
  sha256 "2e3764512aaf2ce598af5a38818c0ea23dedf1ff5460070d1b6cee5c3336e797"

  bottle do
    cellar :any
    sha256 "d82c6b7c72707aa04eb00bd3e6a4a995ef830b41b02271111ee6006585eaca80" => :sierra
    sha256 "c80c64fdd7d05bf0e387b3286238e1740e7989098ba6bde403151a1c14d57812" => :el_capitan
    sha256 "e2143b25bf7bdc85ddb00b065cf1f72c665d77a6737563cd81a88420bc72e51f" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end

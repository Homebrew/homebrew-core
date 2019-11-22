class Mdbtools < Formula
  desc "Tools to facilitate the use of Microsoft Access databases"
  homepage "https://github.com/brianb/mdbtools/"
  url "https://github.com/brianb/mdbtools/archive/0.7.1.tar.gz"
  sha256 "dcf310dc7b07e7ad2f9f6be16047dc81312cfe1ab1bd94d0fa739c8059af0b16"
  revision 3

  bottle do
    cellar :any
    sha256 "3c14e11a6603273676d09141b8da9fed42bacd992dbb7d82979c1279ed488ba4" => :catalina
    sha256 "7ba58781f1d60f4b5ea1e9af6f75d52be36a7cfec10fef414e1e99d447ad10e5" => :mojave
    sha256 "57bc1d0d1df78a20881b0d0340a302ec3a7d359a80eaffe78d809bf4dc150521" => :high_sierra
    sha256 "1e1f75dc87ac2f423ecbf993a118220fe8d309ad179ec9986d099b98f959f216" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "readline"

  def install
    ENV.deparallelize

    system "autoreconf", "-i", "-f"
    system "./configure", "--prefix=#{prefix}", "--disable-man"
    system "make", "install"
  end
end

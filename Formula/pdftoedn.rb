class Pdftoedn < Formula
  desc "Extract PDF document data and save the output in EDN format"
  homepage "https://github.com/edporras/pdftoedn"
  url "https://github.com/edporras/pdftoedn/archive/v0.32.0.tar.gz"
  sha256 "90406cb6954d01514dcea2fb6e857437afd3e8d067b81a2362a7ef6e383919bc"

  bottle do
    cellar :any
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "poppler"
  depends_on "boost"
  depends_on "leptonica"
  depends_on "openssl"
  depends_on "rapidjson"

  def install
    ENV.cxx11 if MacOS.version < :mavericks

    system "autoreconf", "-i"
    system "./configure", "--with-openssl=/usr/local/opt/openssl/", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    # working on converting my ruby-based test suite but all the docs
    # are private. Need to find a public set I can use.
    system "#{bin}/pdftoedn", "-h"
  end
end

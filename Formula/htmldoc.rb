class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/htmldoc/"
  url "https://github.com/michaelrsweet/htmldoc/archive/v1.9.16.tar.gz"
  sha256 "f0d19d8be0fd961d07556f85dbea1d95f0d38728a45dc0f2cf92c715e4140542"
  license "GPL-2.0-only"
  head "https://github.com/michaelrsweet/htmldoc.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "8cdac6cf0ecdd40a8b9e3f9c4b43dcb70b907a334b7e3828b008c15898b04b1d"
    sha256 arm64_big_sur:  "c6fa3410c8a048d651cedf14b2266fa72b9f2fd50fa15ab79b978cd69ca71b79"
    sha256 monterey:       "8a34873ddee81da158ef8c31764de1d1abfee31e47a09e9186338cd72742e611"
    sha256 big_sur:        "0d25208b4ca215b4cda2a8d9871c5fc6c5923dcdcc0298515029db80aa31a065"
    sha256 catalina:       "bb3a9d85875ec4d166deab5e5d4281b72399d01c5343035e988cf64f651e14ac"
    sha256 x86_64_linux:   "cbb3b4d685e129ca007d7da8455273edad23470034da8fc450a0363ebc91a53d"
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libpng"

  def install
    system "./configure", "--disable-debug",
                          "--disable-ssl",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/htmldoc", "--version"
  end
end

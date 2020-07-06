class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.12.2.tar.gz"
  sha256 "ac288b047d1156fc5e739062b11242bad0487993631e79781aede620ddf18cd7"
  license "AGPL-3.0"
  revision 1

  bottle do
    cellar :any
    sha256 "fb9832b774098bf5d586c16e474ff9be1660f752534587c977ca83bbc0fdcd82" => :catalina
    sha256 "4ae15b65746317b11c64ab5aa1566c8988c7a0f4f99b8266d89757137defaf3d" => :mojave
    sha256 "91262185e2d1eef7dd824bcf937c1be40dd234ed2eed6d763d63735cd5dfb125" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "libextractor"
  depends_on "libgcrypt"
  depends_on "libidn2"
  depends_on "libmicrohttpd"
  depends_on "libmpc"
  depends_on "libunistring"
  depends_on "unbound"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/gnunet-config -s arm")
    assert_match "BINARY = gnunet-service-arm", output
  end
end

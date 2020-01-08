class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.12.0.tar.gz"
  sha256 "2184ace2960e4757969f3cd6bc0dba6f136871bf7bcca5d80a7147bde0d2e0af"

  bottle do
    cellar :any
    sha256 "520a4d27877f4afc81a511b88d7ede3ec09d05b81082f605eb9653741f9bded2" => :catalina
    sha256 "39bd112683e2cf7cd551b14ea69f8ea82193b9722136338244e8fbde164de31f" => :mojave
    sha256 "2db03279ed2cde7853f04cbdd82a8092928bda81d393ec68629b8c28cfc0a19f" => :high_sierra
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

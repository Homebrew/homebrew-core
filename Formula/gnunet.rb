class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.11.5.tar.gz"
  sha256 "98e0355ff0627bf88112b3b92a7522e98c0ae6071fc45efda5a33daed28199b3"
  revision 1

  bottle do
    cellar :any
    sha256 "71d8117316def6e7776199ff2fc43fe811a2395d9161394999a506ac4136498b" => :mojave
    sha256 "53370b0158832d898ed742b17e09fcbe0639c51a028484562d5b09cbe19d5ea6" => :high_sierra
    sha256 "66cff228853f8f0bc767082b37a6bd315083ff8d8d5f58b888574b82fce1f9ed" => :sierra
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

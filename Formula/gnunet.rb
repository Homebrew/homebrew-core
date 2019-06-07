class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.11.5.tar.gz"
  sha256 "98e0355ff0627bf88112b3b92a7522e98c0ae6071fc45efda5a33daed28199b3"

  bottle do
    cellar :any
    sha256 "3c2971584ed0a709b5c59c3f844e5966049b90461043af93ba10e167c134a284" => :mojave
    sha256 "81e3f400e41674f919a2656217bd4e1ce825505d9e3939acdc0b3efcfa8949d4" => :high_sierra
    sha256 "0d5a57bacf57f3a78b2a96e1c0b9d22db5385255211b5bd9b8334ffe57925136" => :sierra
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

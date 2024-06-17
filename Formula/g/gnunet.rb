class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.21.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnunet/gnunet-0.21.1.tar.gz"
  sha256 "93e68b3eaca7087273e3d7685fe6ae38b2e8055e4c9e700d360dd4055249785c"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3c3a8f7934ccac6b02d4d75d83aba5042dc46a41d2d38fc7912c72d15008f9ee"
    sha256 cellar: :any,                 arm64_ventura:  "62ddf223d41f85a7c50557cecebbe859def4d2e585f2dcc129ded906f0dd997d"
    sha256 cellar: :any,                 arm64_monterey: "90a6b344c235a97cb96ed2c740329ca6ef62c5063aa00fb4bf77d3706a954874"
    sha256 cellar: :any,                 sonoma:         "c53410a463c9cefe0311e3a4c11ee312b91c064778e339514e0f1bd0dc9143e8"
    sha256 cellar: :any,                 ventura:        "3fdb453508259ffa704970058fa8aec18b6cb4d72ed3001e3928e4f5e1f0685b"
    sha256 cellar: :any,                 monterey:       "32a87990c7e665847610061d0e26839bbb59deb64cfd6440742c2304d0a08aba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43ba4d2f1d0a026200b3f9597eee684d4482ed1d059c6f1fbf724cdd8b4127fd"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "libextractor"
  depends_on "libgcrypt"
  depends_on "libidn2"
  depends_on "libmicrohttpd"
  depends_on "libsodium"
  depends_on "libunistring"

  uses_from_macos "curl", since: :ventura # needs curl >= 7.85.0
  uses_from_macos "sqlite"

  def install
    ENV.deparallelize if OS.linux?
    system "./configure", *std_configure_args, "--disable-documentation"
    system "make", "install"
  end

  test do
    system "#{bin}/gnunet-config", "--rewrite"
    output = shell_output("#{bin}/gnunet-config -s arm")
    assert_match "BINARY = gnunet-service-arm", output
  end
end

class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.19.3.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnunet/gnunet-0.19.3.tar.gz"
  sha256 "82b7d5fe12d481387c37d2fbf032bb605c2e4d5976079a1947943243e5ba7a25"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "541d11f079c02bbdfc662f5f1a3eeaba0b43659d89b2323742c2d48704b40944"
    sha256 cellar: :any,                 arm64_monterey: "7597ed3ab8e78c7d9dd33ce7f63493270dbbfadeaf4044c18587352dc467c669"
    sha256 cellar: :any,                 arm64_big_sur:  "44305ee85dab99b712d40799bcf88256cc6d04ea0e1436740b85197e99249992"
    sha256 cellar: :any,                 ventura:        "61727ff1a7865ac62b0b5048e1130ab990259891c8b0ee270c6e29c57d793697"
    sha256 cellar: :any,                 monterey:       "b71811b39e59e1dc745755d6094a8f2a755bd264cc66807d09626c685e242f61"
    sha256 cellar: :any,                 big_sur:        "c10e15ecc81e3be5d3ebb3c72a6993d79b3eeb110f8d4c8e6e365c3a73c9a815"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "965071c9abc1317ed5bfa61dcf35e396d205a9394afd053d04e28e6fcd7aa895"
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

  uses_from_macos "curl"
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

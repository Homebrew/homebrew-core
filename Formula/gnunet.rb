class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.17.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnunet/gnunet-0.17.4.tar.gz"
  sha256 "ba5a825550db429265beb73a54b1778e27a529ea841df5ef75021e65100c926e"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "43c8796dcf86e8a3b0589845d1a77b593f37d749dcfad17c21ff556c8bb3123c"
    sha256 cellar: :any,                 arm64_big_sur:  "a11be9ffdf11d67f83fa77db9b051505a5199fd6885816661bbd5966f3376f06"
    sha256 cellar: :any,                 monterey:       "451ecf355c1c03d9d6cd1aa0e8743b7c2c844bacd6d75bcbf21f9b90b384c3b0"
    sha256 cellar: :any,                 big_sur:        "e7cac4b10d9df37e204e29e1042d1a76e768cd1e1285028dbdfcde9f67dfae97"
    sha256 cellar: :any,                 catalina:       "e8848edc9374f91268506edc59358dee20dfd881036b18c03bed395a1bd07f21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b31ad691b7caf59a1909bc7fb1246608728768074254e49f62cd9923d4cf5aa"
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

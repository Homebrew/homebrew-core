class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.14.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnunet/gnunet-0.14.1.tar.gz"
  sha256 "4a3205c570c30756f1a8b1ad0f1a63d078a92f0fac8e543471d54f4552da18c2"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "913d3a808c3beaacaa7aa0307c200af943f539bc5203a4b2c62e6e6e9919eee8"
    sha256 cellar: :any,                 big_sur:       "b97c192441e2b2836c0dfead9f2e85cfea8ae0889e34510436be4b3dc427b944"
    sha256 cellar: :any,                 catalina:      "fa620c92930b29e01dc564f14867462126cf508692be8b9c3ca5c716419c6f7c"
    sha256 cellar: :any,                 mojave:        "8f032fccf8877f461e5ccf87d059a9649ca056493b984a931ddc97317f45512a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77d500a6ec053927f4df368c4a9c230844b50f30e787d14a268becf8d6c95355"
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
  depends_on "libsodium"
  depends_on "libunistring"
  depends_on "unbound"

  uses_from_macos "curl"
  uses_from_macos "sqlite"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/gnunet-config -s arm")
    assert_match "BINARY = gnunet-service-arm", output
  end
end

class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.19.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnunet/gnunet-0.19.4.tar.gz"
  sha256 "00a63df408d5987f5ba9a50441f2a77182bd9fb32f1e302ae563ac94e7ac009b"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "514ee11b8630e669cda7e0d1b0e2c745162e2f86b4c2dfb6eb788360245937b0"
    sha256 cellar: :any,                 arm64_monterey: "d6a203f6fc633b95ef2389462491fb77185bff0b0ca0a3c622557894fac2e691"
    sha256 cellar: :any,                 arm64_big_sur:  "2b53b22594fea3e621e3b05454df32c18b46c34d616c47947e12a6899326a09f"
    sha256 cellar: :any,                 ventura:        "38e7c11e9bc791cfabcef325aeadf96d3f6af9b1a395be3713448cf300b2f9f1"
    sha256 cellar: :any,                 monterey:       "4c661ee410bc6dae1f5e2f60bcd8bf4a1e0bc0384c017f20f4662cd781b1d539"
    sha256 cellar: :any,                 big_sur:        "9084cdded8f4fefa9586551fbb98ef34539230ae73602b1c0b5024d13b11238b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c73b33d353fb74889f491e2452670af8b76d0e5a2cd2b60dfd9e9a7173aef4f7"
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
